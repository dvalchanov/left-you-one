require "rails_helper"

RSpec.describe RecipientPreview do
  let!(:template) do
    create(
      :gift_template,
      source_key: "recipient_preview_courage",
      main_text: "A little courage before your doubts wake up.",
      context_text: "For the thing you’ve been putting off.",
      ritual_text: "Keep it until you begin.",
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "first_light_window"
    )
  end

  it "builds a synthetic preview without persisting product state" do
    expect do
      preview = described_class.build(template: template.source_key, sender: "  Dimitar  ")

      expect(preview.template).to eq(template)
      expect(preview.sender_name).to eq("Dimitar")
      expect(preview.state).to eq("arrival")
    end.not_to change { [ Gift.count, Transfer.count, JourneyStop.count ] }
  end

  it "uses neutral anonymous-sender copy" do
    preview = described_class.build(template: template.source_key, anonymous_sender: "1")

    expect(preview.sender_name).to be_nil
    expect(preview.arrival_line).to eq(I18n.t("recipient.arrival.anonymous_sender"))
    expect(preview.arrival_context).to eq(I18n.t("recipient.arrival.context_anonymous"))
  end

  it "supports long authored content without lorem ipsum" do
    preview = described_class.build(template: template.source_key, long_text: "1")

    expect(preview.main_text).to eq(described_class::LONG_MAIN_TEXT)
    expect(preview.context_text).to eq(described_class::LONG_CONTEXT_TEXT)
    expect(preview.ritual_text).to eq(described_class::LONG_RITUAL_TEXT)
    expect(preview.private_note).to eq(described_class::LONG_NOTE)
  end

  it "bounds journey inputs and ignores unknown state" do
    preview = described_class.build(holder_count: "500", days: "-3", state: "claimed", places: "Sofia, , Vienna")

    expect(preview.holder_count).to eq(99)
    expect(preview.days_travelling).to eq(0)
    expect(preview.state).to eq("arrival")
    expect(preview.places).to eq(%w[Sofia Vienna])
  end

  it "never includes private capability parameters in a clean preview URL" do
    preview = described_class.build(
      template: template.source_key,
      claim_token: "secret",
      creator_manage_token: "also-secret"
    )

    expect(preview.query_params.to_s).not_to include("secret", "token")
  end
end
