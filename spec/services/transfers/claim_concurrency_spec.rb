require "rails_helper"

RSpec.describe "Concurrent transfer claims", type: :service do
  self.use_transactional_tests = false

  before do
    @raw_claim_token = "simultaneous recipient claim #{SecureRandom.hex(8)}"
    @gift = create(:gift, state: "waiting_for_claim", holder_generation: 0)
    create(
      :transfer,
      gift: @gift,
      state: "pending",
      source_holder_generation: 0,
      claim_token_digest: CapabilityToken.digest(@raw_claim_token)
    )
  end

  after do
    JourneyStop.where(gift_id: @gift.id).delete_all
    Transfer.where(gift_id: @gift.id).delete_all
    Gift.where(id: @gift.id).delete_all
    GiftTemplate.where(id: @gift.gift_template_id).delete_all
  end

  it "lets exactly one simultaneous claimant become the first holder" do
    ready = Queue.new
    release = Queue.new

    threads = 2.times.map do
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          release.pop
          Transfers::Claim.call(raw_token: @raw_claim_token)
        end
      end
    end

    2.times { ready.pop }
    2.times { release << true }
    results = threads.map(&:value)

    expect(results.map(&:status)).to contain_exactly(:claimed, :already_claimed)
    expect(@gift.reload).to have_attributes(state: "held", holder_generation: 1)
    expect(@gift.journey_stops.count).to eq(1)
  end
end
