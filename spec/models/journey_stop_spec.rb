require "rails_helper"

RSpec.describe JourneyStop, type: :model do
  it "requires a unique sequence within each gift" do
    existing = create(:journey_stop)
    duplicate = build(:journey_stop, gift: existing.gift, transfer: nil, sequence: existing.sequence)

    expect(duplicate).not_to be_valid
  end

  it "allows an anonymous stop with no public identity" do
    stop = build(:journey_stop, anonymous: true, display_name: nil, city: nil, country_code: nil)

    expect(stop).to be_valid
  end

  it "accepts only an uppercase two-letter country code when supplied" do
    expect(build(:journey_stop, country_code: "BG")).to be_valid
    expect(build(:journey_stop, country_code: "Bulgaria")).not_to be_valid
  end

  it "allows at most one stop for a transfer" do
    existing = create(:journey_stop)
    duplicate = build(:journey_stop, gift: existing.gift, transfer: existing.transfer, sequence: 2)

    expect(duplicate).not_to be_valid
  end

  it "does not depend on a user account" do
    associations = described_class.reflect_on_all_associations.map(&:name)

    expect(associations).to contain_exactly(:gift, :transfer)
  end
end
