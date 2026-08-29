require "rails_helper"

RSpec.describe Transfer, type: :model do
  it "accepts every supported state" do
    described_class::STATES.each do |state|
      expect(build(:transfer, state:)).to be_valid
    end
  end

  it "rejects an unsupported state" do
    expect(build(:transfer, state: "opened")).not_to be_valid
  end

  it "requires a unique claim digest" do
    existing = create(:transfer, state: "claimed")

    expect(build(:transfer, claim_token_digest: existing.claim_token_digest)).not_to be_valid
  end

  it "allows only one pending transfer per gift" do
    existing = create(:transfer)

    expect(build(:transfer, gift: existing.gift)).not_to be_valid
    expect(build(:transfer, gift: existing.gift, state: "cancelled")).to be_valid
  end

  it "requires both people needed for a handoff" do
    expect(build(:transfer, sender_display_name: nil)).not_to be_valid
    expect(build(:transfer, intended_recipient_name: nil)).not_to be_valid
  end

  it "excludes the private note from ordinary serialization" do
    transfer = build(:transfer, private_note: "Only Anna should read this.")

    expect(transfer.as_json).not_to have_key("private_note")
    expect(transfer.private_note).to eq("Only Anna should read this.")
  end
end
