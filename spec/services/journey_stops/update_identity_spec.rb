require "rails_helper"

RSpec.describe JourneyStops::UpdateIdentity do
  let(:holder_token) { "holder capability" }
  let(:gift) do
    create(
      :gift,
      state: "held",
      holder_generation: 1,
      current_holder_token_digest: CapabilityToken.digest(holder_token)
    )
  end
  let!(:stop) { create(:journey_stop, gift:, transfer: nil, sequence: 1) }

  it "adds only the holder's explicitly supplied public mark" do
    described_class.call(
      gift:,
      holder_token:,
      holder_generation: 1,
      anonymous: false,
      display_name: "Anna",
      city: "Sofia",
      country_code: "bg"
    )

    expect(stop.reload).to have_attributes(
      anonymous: false,
      display_name: "Anna",
      city: "Sofia",
      country_code: "BG"
    )
  end

  it "can return the stop to anonymous" do
    stop.update!(anonymous: false, display_name: "Anna", city: "Sofia", country_code: "BG")

    described_class.call(
      gift:,
      holder_token:,
      holder_generation: 1,
      anonymous: true,
      display_name: "Anna",
      city: "Sofia",
      country_code: "BG"
    )

    expect(stop.reload).to have_attributes(anonymous: true, display_name: nil, city: nil, country_code: nil)
  end
end
