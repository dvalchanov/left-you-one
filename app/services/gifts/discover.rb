require "securerandom"

module Gifts
  class Discover
    MAX_COLLISION_ATTEMPTS = 3
    Result = Data.define(:gift, :creator_manage_token)

    def self.call(gift_template:, render_seed: nil)
      new(gift_template:, render_seed:).call
    end

    def initialize(gift_template:, render_seed:)
      @gift_template = gift_template
      @render_seed = render_seed
    end

    def call
      attempts = 0

      begin
        attempts += 1
        create_gift
      rescue ActiveRecord::RecordNotUnique
        retry if attempts < MAX_COLLISION_ATTEMPTS

        raise
      end
    end

    private

    attr_reader :gift_template, :render_seed

    def create_gift
      Gift.transaction(requires_new: true) do
        creator_token = CapabilityToken.issue
        gift = Gift.create!(
          gift_template:,
          public_slug: SecureRandom.urlsafe_base64(12, false),
          state: :discovered,
          render_seed: render_seed || SecureRandom.random_number(2**31),
          creator_manage_token_digest: creator_token.digest,
          holder_generation: 0,
          discovered_at: Time.current
        )

        Result.new(gift: gift.reload, creator_manage_token: creator_token.raw)
      end
    end
  end
end
