require "rails_helper"

RSpec.describe Gifts::ActivateForRecipient do
  let(:creator_token) { "creator capability" }
  let(:gift) do
    create(
      :gift,
      creator_manage_token_digest: CapabilityToken.digest(creator_token),
      state: "discovered"
    )
  end

  def activate(claim_token: "claim capability", recipient: "Anna")
    described_class.call(
      gift:,
      creator_token:,
      sender_display_name: "Dimitar",
      intended_recipient_name: recipient,
      private_note: "For tomorrow.",
      claim_token:
    )
  end

  it "creates one pending transfer and turns simulated commitment into waiting" do
    result = activate

    expect(result.transfer).to be_pending
    expect(result.claim_token).to eq("claim capability")
    expect(result.transfer.private_note).to eq("For tomorrow.")
    expect(gift.reload).to be_waiting_for_claim
    expect(gift.origin_name).to eq("Dimitar")
    expect(gift.activated_at).to be_present
  end

  it "is idempotent for the same claim capability" do
    first = activate
    second = activate

    expect(second.transfer).to eq(first.transfer)
    expect(gift.transfers.pending.count).to eq(1)
  end

  it "cancels the old pending transfer when the creator replaces the recipient" do
    old_transfer = activate.transfer
    replacement = activate(claim_token: "replacement capability", recipient: "Maya")

    expect(old_transfer.reload).to be_cancelled
    expect(replacement.replaced).to be(true)
    expect(replacement.transfer.intended_recipient_name).to eq("Maya")
    expect(gift.transfers.pending.count).to eq(1)
  end

  it "rejects a token that is not the creator capability" do
    expect do
      described_class.call(
        gift:,
        creator_token: "wrong",
        sender_display_name: "Dimitar",
        intended_recipient_name: "Anna",
        private_note: nil
      )
    end.to raise_error(described_class::Unauthorized)
  end
end
