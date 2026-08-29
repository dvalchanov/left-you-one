require "rails_helper"

RSpec.describe Gifts::Discover do
  it "creates only one discovered gift and returns its creator capability once" do
    template = create(:gift_template)

    result = described_class.call(gift_template: template, render_seed: 12_345)
    gift = result.gift

    expect(gift).to be_persisted
    expect(gift).to be_discovered
    expect(gift.render_seed).to eq(12_345)
    expect(gift.holder_generation).to eq(0)
    expect(gift.discovered_at).to be_present
    expect(gift.opened_by_creator_at).to eq(gift.discovered_at)
    expect(gift.serial_number).to be_present
    expect(gift.display_serial_number).to match(/\A#\d{6,}\z/)
    expect(gift.public_slug).to match(/\A[A-Za-z0-9_-]{16}\z/)
    expect(gift.visual_configuration).to include(
      "visual_family" => "paper_world",
      "sealed_treatment" => "closed_frame"
    )
    expect(gift.transfers).to be_empty
    expect(gift.journey_stops).to be_empty
  end

  it "stores only the creator token digest" do
    result = described_class.call(gift_template: create(:gift_template))
    gift = result.gift

    expect(result.creator_manage_token).to be_present
    expect(gift.creator_manage_token_digest).not_to eq(result.creator_manage_token)
    expect(gift.attributes.values).not_to include(result.creator_manage_token)
    expect(CapabilityToken.matches?(result.creator_manage_token, gift.creator_manage_token_digest)).to be(true)
  end


  it "makes repeated creation with the same browser key idempotent" do
    template = create(:gift_template)
    creator_token = CapabilityToken.issue.raw

    first = described_class.call(
      gift_template: template,
      creation_key: "one browser submission",
      creator_manage_token: creator_token
    )
    second = described_class.call(
      gift_template: template,
      creation_key: "one browser submission",
      creator_manage_token: creator_token
    )

    expect(second.gift).to eq(first.gift)
    expect(second.creator_manage_token).to eq(creator_token)
    expect(Gift.where(creation_key_digest: CapabilityToken.digest("one browser submission")).count).to eq(1)
  end
end
