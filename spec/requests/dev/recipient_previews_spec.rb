require "rails_helper"

RSpec.describe "Development recipient previews", type: :request do
  let!(:template) do
    create(
      :gift_template,
      source_key: "recipient_request_preview",
      main_text: "Ten quiet minutes with nothing to prove.",
      context_text: "For the day that will not stop asking things of you.",
      ritual_text: "Use them slowly.",
      visual_family: "paper",
      finish: "soft_grain",
      background_key: "curtain_light"
    )
  end

  it "makes the visual laboratory available in development and test" do
    get dev_recipient_lab_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include(I18n.t("prototype.recipient_lab.title"))
    expect(response.body).to include(dev_recipient_preview_path)
  end

  it "renders a clean preview without development controls" do
    get dev_recipient_preview_path, params: { template: template.source_key, sender: "Maya", recipient: "Anna" }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Maya left you something.", "They wanted you to have it.", "This is for you, Anna.", template.main_text)
    expect(response.body).not_to include(I18n.t("prototype.recipient_lab.title"), "Randomize treatment")
  end

  it "renders the sender's pre-commitment comparison without implying a charge" do
    get dev_recipient_preview_path, params: {
      template: template.source_key,
      viewer: "sender",
      state: "with_you",
      recipient: "Anna",
      price: "$3"
    }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("You saw this and thought of Anna.", "Leave this for Anna · $3")
    expect(response.body).to include(I18n.t("prototype.notice"))
  end

  it "falls invalid visual configuration back to known local values" do
    get dev_recipient_preview_path, params: {
      template: template.source_key,
      visual_family: "unknown",
      background: "https://example.com/tracker.jpg",
      composition: "position:fixed",
      state: "hacked"
    }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("prototype/receiver/paper-world")
    expect(response.body).to include("composition-bottom_left")
    expect(response.body).not_to include("example.com", "position:fixed", "data-state=\"hacked\"")
  end

  it "does not mutate gifts, transfers, or journey stops" do
    expect do
      get dev_recipient_lab_path, params: { template: template.source_key, state: "existing_journey" }
      get dev_recipient_preview_path, params: { template: template.source_key, state: "with_you" }
    end.not_to change { [ Gift.count, Transfer.count, JourneyStop.count ] }
  end

  it "is unavailable when the application is running in production" do
    allow(Rails).to receive(:env).and_return(ActiveSupport::EnvironmentInquirer.new("production"))

    get "/dev/recipient-preview"

    expect(response).to have_http_status(:not_found)
  end
end
