require "rails_helper"

RSpec.describe "recipient_experiences/_stage", type: :view do
  let!(:template) do
    create(
      :gift_template,
      source_key: "recipient_view_preview",
      main_text: "A little courage before your doubts wake up.",
      context_text: "For the thing you’ve been putting off.",
      ritual_text: "Keep it until you begin.",
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "first_light_window"
    )
  end

  def render_preview(parameters = {})
    preview = RecipientPreview.build({ template: template.source_key }.merge(parameters))
    render partial: "recipient_experiences/stage", locals: { preview: }
    Capybara.string(rendered)
  end

  it "renders named sender and recipient context through I18n" do
    allow(I18n).to receive(:t).and_call_original

    page = render_preview(sender: "Dimitar", recipient: "Anna")

    expect(page).to have_text("Dimitar left you something.")
    expect(page).to have_text("They wanted you to have it.")
    expect(page).to have_text("This is for you, Anna.")
    expect(I18n).to have_received(:t).with("recipient.arrival.named_sender", sender: "Dimitar")
  end

  it "keeps persistent product branding out of the recipient stage" do
    page = render_preview

    expect(page).not_to have_text(I18n.t("brand.name"))
    expect(page).not_to have_css(".recipient-stage__brand")
  end

  it "keeps the prototype serial out of the emotional reveal" do
    page = render_preview(state: "revealed")

    expect(page.text).not_to match(/#\d{6}/)
  end

  it "renders the anonymous sender fallback" do
    page = render_preview(anonymous_sender: "1")

    expect(page).to have_text(I18n.t("recipient.arrival.anonymous_sender"))
    expect(page).to have_text(I18n.t("recipient.arrival.context_anonymous"))
  end

  it "keeps gift copy and the private note hidden in the arrival state" do
    page = render_preview(state: "arrival", note: "Only Anna should read this.")

    expect(page).to have_css("[data-recipient-experience-target='reveal'][hidden]", text: template.main_text, visible: :all)
    expect(page).to have_css("[data-recipient-experience-target='reveal'][aria-hidden='true']", text: "Only Anna should read this.", visible: :all)
    expect(page).to have_button(I18n.t("recipient.open"))
  end

  it "renders main, context, ritual, and private-note layers after reveal" do
    page = render_preview(state: "revealed", note: "Only Anna should read this.")

    expect(page).to have_text(template.main_text)
    expect(page).to have_text(template.context_text)
    expect(page).to have_text(template.ritual_text)
    expect(page).to have_text("Only Anna should read this.")
    expect(page).to have_css(
      "[data-recipient-experience-target='possession'][aria-hidden='true']:not([hidden])",
      text: I18n.t("holder.possession"),
      visible: :all
    )
  end

  it "renders possession and existing journey as secondary information" do
    page = render_preview(
      state: "existing_journey",
      sender: "Maya",
      holder_count: "7",
      places: "Sofia, Vienna, Berlin",
      days: "19"
    )

    expect(page).to have_text(I18n.t("holder.possession"))
    expect(page).to have_text("This one began with Maya 19 days ago.")
    expect(page).to have_text("You’re its 7th holder.")
    expect(page).to have_text("Sofia → Vienna → Berlin")
    expect(page).to have_text("7 people · 3 countries · 19 days")
  end

  it "frames the same reveal as sender anticipation before simulated commitment" do
    page = render_preview(viewer: "sender", state: "with_you", recipient: "Anna", price: "$3")

    expect(page).to have_text("This is what Anna opens.")
    expect(page).to have_css(".recipient-stage[aria-label='A preview of the gift for Anna']")
    expect(page).to have_text("You saw this and thought of Anna.")
    expect(page).to have_text("That’s what makes it a gift.")
    expect(page).to have_button("Leave this for Anna · $3")
    expect(page).to have_text(I18n.t("prototype.notice"))
    expect(page).not_to have_text("When somebody else comes to mind, pass it on.")
  end

  it "does not omit required layers in the long-content variation" do
    page = render_preview(state: "with_you", long_text: "1")

    expect(page).to have_text(RecipientPreview::LONG_MAIN_TEXT)
    expect(page).to have_text(RecipientPreview::LONG_CONTEXT_TEXT)
    expect(page).to have_text(RecipientPreview::LONG_RITUAL_TEXT)
    expect(page).to have_text(RecipientPreview::LONG_NOTE)
    expect(page).to have_text(I18n.t("holder.keep"))
  end
end
