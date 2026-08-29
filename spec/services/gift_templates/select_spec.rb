require "rails_helper"

RSpec.describe GiftTemplates::Select do
  before { GiftTemplate.update_all(active: false) }

  it "selects an active template from the requested theme" do
    create(:gift_template, theme: "calm", active: false)
    expected = create(:gift_template, theme: "calm", active: true)
    create(:gift_template, theme: "courage", active: true)

    expect(described_class.call(theme: "calm", random: Random.new(1))).to eq(expected)
  end

  it "uses every active theme for surprise" do
    create(:gift_template, theme: "calm", active: false)
    expected = create(:gift_template, theme: "wonder", active: true)

    expect(described_class.call(theme: "surprise", random: Random.new(1))).to eq(expected)
  end

  it "rejects unknown and empty selections clearly" do
    expect { described_class.call(theme: "rare") }.to raise_error(described_class::InvalidTheme)
    expect { described_class.call(theme: "luck") }.to raise_error(described_class::NoneAvailable)
  end
end
