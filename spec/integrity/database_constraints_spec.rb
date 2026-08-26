require "rails_helper"

RSpec.describe "Accountless domain database constraints" do
  it "enforces unique template source keys without validations" do
    existing = create(:gift_template)

    expect do
      build(:gift_template, source_key: existing.source_key).save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "enforces unique gift serial numbers without validations" do
    existing = create(:gift).reload
    duplicate = build(:gift, serial_number: existing.serial_number)

    expect do
      duplicate.save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "enforces unique public slugs without validations" do
    existing = create(:gift)

    expect do
      build(:gift, public_slug: existing.public_slug).save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "enforces unique creator digests without validations" do
    creator_digest = CapabilityToken.digest("first creator")
    create(:gift, creator_manage_token_digest: creator_digest)

    expect do
      build(:gift, creator_manage_token_digest: creator_digest).save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "enforces unique current-holder digests without validations" do
    holder_digest = CapabilityToken.digest("first holder")
    create(:gift, current_holder_token_digest: holder_digest)

    expect do
      build(:gift, current_holder_token_digest: holder_digest).save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "enforces unique transfer claim digests without validations" do
    existing = create(:transfer, state: "claimed")

    expect do
      build(:transfer,
        state: "cancelled",
        claim_token_digest: existing.claim_token_digest).save!(validate: false)
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "prevents two pending transfers for one gift even without validations" do
    existing = create(:transfer)

    expect do
      Transfer.insert_all!([ {
        gift_id: existing.gift_id,
        claim_token_digest: CapabilityToken.digest("another claim"),
        state: "pending",
        source_holder_generation: 0
      } ])
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "allows historical non-pending transfers for the same gift" do
    existing = create(:transfer)

    expect do
      create(:transfer, gift: existing.gift, state: "cancelled")
    end.to change(Transfer, :count).by(1)
  end

  it "prevents duplicate journey sequences even without validations" do
    existing = create(:journey_stop)

    expect do
      JourneyStop.insert_all!([ {
        gift_id: existing.gift_id,
        sequence: existing.sequence,
        anonymous: true,
        arrived_at: Time.current
      } ])
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "prevents a second journey stop for one transfer even without validations" do
    existing = create(:journey_stop)

    expect do
      JourneyStop.insert_all!([ {
        gift_id: existing.gift_id,
        transfer_id: existing.transfer_id,
        sequence: 2,
        anonymous: true,
        arrived_at: Time.current
      } ])
    end.to raise_error(ActiveRecord::RecordNotUnique)
  end

  it "rejects negative holder generations" do
    gift = create(:gift)

    expect do
      Gift.where(id: gift.id).update_all(holder_generation: -1)
    end.to raise_error(ActiveRecord::StatementInvalid, /gifts_holder_generation_check/)
  end

  it "rejects journey sequence zero" do
    gift = create(:gift)

    expect do
      JourneyStop.insert_all!([ {
        gift_id: gift.id,
        sequence: 0,
        anonymous: true,
        arrived_at: Time.current
      } ])
    end.to raise_error(ActiveRecord::StatementInvalid, /journey_stops_sequence_check/)
  end
end
