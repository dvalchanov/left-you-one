require "rails_helper"

RSpec.describe GiftVisuals::Catalog do
  subject(:catalog) { described_class.current }

  let(:template) do
    build(
      :gift_template,
      visual_family: "luminous",
      finish: "soft_grain",
      background_key: "first_light_window"
    )
  end

  it "provides six related but distinct visual families" do
    expect(catalog.choices(:families).map { |family| family.fetch("key") }).to contain_exactly(
      "quiet_light",
      "distant_horizon",
      "after_rain",
      "night_window",
      "close_detail",
      "strange_stillness"
    )
  end

  it "maps the existing template vocabulary to the editable visual catalog" do
    visual = catalog.resolve(template:)

    expect(visual.family_key).to eq("quiet_light")
    expect(visual.asset).to eq("prototype/receiver/quiet-light.webp")
    expect(visual.finish).to eq("soft_grain")
  end

  it "falls back safely when preview overrides are invalid" do
    visual = catalog.resolve(
      template:,
      overrides: {
        visual_family: "javascript:alert(1)",
        background: "../../private",
        composition: "anywhere",
        text_tone: "invisible"
      }
    )

    expect(visual.family_key).to eq("quiet_light")
    expect(visual.background_key).to eq("quiet_light")
    expect(visual.composition).to eq("bottom_left")
    expect(visual.text_tone).to eq("dark")
  end
end
