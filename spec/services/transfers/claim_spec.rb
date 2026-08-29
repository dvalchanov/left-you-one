require "rails_helper"

RSpec.describe Transfers::Claim do
  let(:raw_claim_token) { "recipient claim capability" }
  let(:gift) { create(:gift, state: "waiting_for_claim", holder_generation: 0) }
  let!(:transfer) do
    create(
      :transfer,
      gift:,
      state: "pending",
      source_holder_generation: 0,
      intended_recipient_name: "Anna",
      claim_token_digest: CapabilityToken.digest(raw_claim_token)
    )
  end

  it "atomically creates the first holder and journey stop" do
    result = described_class.call(raw_token: raw_claim_token)

    expect(result).to be_success
    expect(transfer.reload).to be_claimed
    expect(gift.reload).to be_held
    expect(gift.holder_generation).to eq(1)
    expect(gift.opened_by_recipient_at).to be_present
    expect(CapabilityToken.matches?(result.holder_token, gift.current_holder_token_digest)).to be(true)
    expect(result.journey_stop).to have_attributes(
      sequence: 1,
      anonymous: true,
      display_name: "Anna",
      city: nil,
      country_code: nil,
      transfer_id: transfer.id
    )
  end

  it "allows only the first claim" do
    first = described_class.call(raw_token: raw_claim_token)
    second = described_class.call(raw_token: raw_claim_token)

    expect(first).to be_success
    expect(second.status).to eq(:already_claimed)
    expect(gift.journey_stops.count).to eq(1)
  end

  it "does not reveal whether a random capability exists" do
    result = described_class.call(raw_token: "random")

    expect(result.status).to eq(:invalid)
    expect(result.gift).to be_nil
  end
end
