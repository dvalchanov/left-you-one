require "rails_helper"

RSpec.describe GiftTemplate, type: :model do
  it "accepts every supported theme" do
    described_class::THEMES.each do |theme|
      expect(build(:gift_template, theme:)).to be_valid
    end
  end

  it "rejects an unsupported theme" do
    expect(build(:gift_template, theme: "inspiration")).not_to be_valid
  end

  it "requires the authored main text" do
    expect(build(:gift_template, main_text: nil)).not_to be_valid
  end

  it "requires a unique source key" do
    existing = create(:gift_template)

    expect(build(:gift_template, source_key: existing.source_key)).not_to be_valid
  end

  it "can be made inactive without deletion" do
    expect(create(:gift_template, active: false)).not_to be_active
  end
end
