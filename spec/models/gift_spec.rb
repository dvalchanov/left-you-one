require "rails_helper"

RSpec.describe Gift, type: :model do
  it "requires a template" do
    expect(build(:gift, gift_template: nil)).not_to be_valid
  end

  it "defaults to discovered with holder generation zero" do
    gift = described_class.new

    expect(gift).to be_discovered
    expect(gift.holder_generation).to eq(0)
  end

  it "requires unique serial numbers" do
    existing = create(:gift).reload

    duplicate = build(:gift)
    duplicate.serial_number = existing.serial_number

    expect(duplicate).not_to be_valid
  end

  it "requires unique public slugs" do
    existing = create(:gift)

    expect(build(:gift, public_slug: existing.public_slug)).not_to be_valid
  end

  it "has only accountless domain associations" do
    associations = described_class.reflect_on_all_associations.map(&:name)

    expect(associations).to include(:gift_template, :transfers, :journey_stops)
    expect(associations).not_to include(:user, :sender, :recipient, :owner)
  end
end
