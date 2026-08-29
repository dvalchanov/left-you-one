require "rails_helper"
require "uri"

RSpec.describe "Core sender-to-recipient flow", type: :request do
  let!(:template) do
    create(
      :gift_template,
      source_key: "core_flow_calm",
      theme: "calm",
      main_text: "Ten quiet minutes with nothing to prove.",
      context_text: "For the day that will not stop asking things of you.",
      ritual_text: "Use them slowly.",
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "afterglow_meadow"
    )
  end

  def create_sender_gift
    get start_path
    creation_key = Nokogiri::HTML(response.body).at_css("input[name='creation_key']")["value"]
    post gifts_path, params: { creation_key:, theme: "calm" }
    follow_redirect!
    follow_redirect!
    Gift.order(:created_at).last
  end

  it "completes discovery, simulated activation, isolated claim, possession, and sender status" do
    gift = create_sender_gift

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(
      gift.gift_template.main_text,
      "This isn’t for anyone yet.",
      "Who came to mind?",
      "They’ll open this exact gift from you"
    )
    expect(response.body).not_to include("Open it when you’re ready.", "Hold for a moment")
    expect(gift.visual_configuration).to include(
      "visual_family" => "paper_world",
      "background" => "paper_world",
      "sealed_treatment" => "closed_frame"
    )

    expect(gift.opened_by_creator_at).to be_present

    post recipient_managed_gift_path(gift.public_slug), params: {
      sender_display_name: "Dimitar",
      intended_recipient_name: "Anna",
      private_note: "For the morning you mentioned."
    }
    follow_redirect!
    expect(response.body).to include("You saw this and thought of Anna.", "Leave this for Anna · $2")

    post activate_managed_gift_path(gift.public_slug)
    follow_redirect!
    expect(gift.reload).to be_waiting_for_claim
    expect(gift.transfers.pending.count).to eq(1)
    expect(response.body).to include("data-testid=\"sealed-gift\"", "sender-sealed-envelope")
    expect(response.body).not_to include(gift.gift_template.main_text)
    claim_url = Nokogiri::HTML(response.body).at_css("[data-flow-target='copySource']")["value"]
    claim_path = URI(claim_url).request_uri

    public_visitor = ActionDispatch::Integration::Session.new(Rails.application)
    public_visitor.get(public_gift_path(gift.public_slug))
    expect(public_visitor.response.body).to include("This is waiting for someone.")
    expect(public_visitor.response.body).not_to include(gift.gift_template.main_text, "Anna", "For the morning you mentioned.")

    recipient = ActionDispatch::Integration::Session.new(Rails.application)
    recipient.get(claim_path)
    expect(recipient.response).to have_http_status(:ok)
    expect(recipient.response.headers["Referrer-Policy"]).to eq("no-referrer")
    expect(recipient.response.body).to include("Dimitar left you something.", "This is for you, Anna.")
    expect(recipient.response.body).not_to include(gift.gift_template.main_text, "For the morning you mentioned.")

    recipient.post("#{claim_path}/claim")
    expect(recipient.response.status).to eq(303)
    expect(URI(recipient.response.location).request_uri).to eq(public_gift_path(gift.public_slug, opening: "1"))
    recipient.follow_redirect!
    expect(recipient.response.body).to include(gift.gift_template.main_text, "For the morning you mentioned.", "It’s with you now.")
    expect(gift.reload).to be_held
    expect(gift.holder_generation).to eq(1)
    expect(gift.journey_stops.count).to eq(1)
    expect(gift.current_journey_stop.reload).to have_attributes(
      anonymous: true,
      display_name: "Anna",
      city: nil,
      country_code: nil
    )
    expect(recipient.response.body).not_to include("Leave your name on its journey?", "Display name", "Private holder access")

    recipient.get(public_gift_journey_path(gift.public_slug))
    expect(recipient.response).to have_http_status(:ok)
    expect(recipient.response.body).to include("It began with Dimitar.", "Now with", "Anna")
    expect(recipient.response.body).not_to include(gift.gift_template.main_text, "City", "Country code")

    public_visitor.get(public_gift_path(gift.public_slug))
    expect(public_visitor.response.body).to include(gift.gift_template.main_text)
    expect(public_visitor.response.body).not_to include("Anna", "For the morning you mentioned.", "intended_recipient_name")
    public_visitor.get(public_gift_journey_path(gift.public_slug))
    expect(public_visitor.response).to have_http_status(:not_found)

    get managed_gift_path(gift.public_slug)
    expect(response.body).to include("Anna opened the gift you started.", "Its journey has begun.", "flow-claimed")
    expect(response.body).not_to include(gift.current_holder_token_digest)

    get public_gift_journey_path(gift.public_slug)
    expect(response).to have_http_status(:ok)
    expect(response.body).to include("It began with Dimitar.", "Now with", "Anna", "Back to sender status")
  end

  it "keeps capabilities private and makes an already-used claim lose cleanly" do
    gift = create_sender_gift
    post recipient_managed_gift_path(gift.public_slug), params: {
      sender_display_name: "Dimitar",
      intended_recipient_name: "Anna"
    }
    follow_redirect!
    post activate_managed_gift_path(gift.public_slug)
    follow_redirect!
    claim_url = Nokogiri::HTML(response.body).at_css("[data-flow-target='copySource']")["value"]
    claim_path = URI(claim_url).request_uri

    first = ActionDispatch::Integration::Session.new(Rails.application)
    first.post("#{claim_path}/claim")
    expect(first.response).to have_http_status(:see_other)

    second = ActionDispatch::Integration::Session.new(Rails.application)
    second.post("#{claim_path}/claim")
    expect(second.response.status).to eq(303)
    expect(URI(second.response.location).request_uri).to eq(claim_path)
    expect(gift.journey_stops.count).to eq(1)

    second.follow_redirect!
    expect(second.response.body).to include("This one has already found someone.", "This private link has already been opened.")
    gift.reload
    expect(second.response.body).not_to include(
      gift.creator_manage_token_digest,
      gift.current_holder_token_digest,
      gift.transfers.first.claim_token_digest
    )
  end

  it "requires the recipient name that will identify the handoff" do
    gift = create_sender_gift

    post recipient_managed_gift_path(gift.public_slug), params: { sender_display_name: "Dimitar" }
    expect(response).to redirect_to(managed_gift_path(gift.public_slug, scene: "recipient"))
    follow_redirect!

    expect(response.body).to include("Add who this is for.")
    expect(response.body).to include("name=\"intended_recipient_name\"", "required=\"required\"")
    expect(gift.transfers).to be_empty
  end

  it "rejects invalid creator, claim, and holder capabilities without exposing state" do
    get creator_capability_path("random")
    expect(response).to have_http_status(:not_found)

    get open_claim_path("random")
    expect(response).to have_http_status(:not_found)
    expect(response.body).to include("There’s nothing to open here.")

    get holder_capability_path("random")
    expect(response).to have_http_status(:not_found)
  end
end
