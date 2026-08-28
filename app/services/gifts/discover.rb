require "securerandom"

module Gifts
  class Discover
    MAX_COLLISION_ATTEMPTS = 3
    Result = Data.define(:gift, :creator_manage_token)

    def self.call(gift_template:, render_seed: nil, creation_key: nil, creator_manage_token: nil, visual_snapshot: nil)
      new(gift_template:, render_seed:, creation_key:, creator_manage_token:, visual_snapshot:).call
    end

    def initialize(gift_template:, render_seed:, creation_key:, creator_manage_token:, visual_snapshot:)
      @gift_template = gift_template
      @render_seed = render_seed
      @creation_key = creation_key
      @creator_manage_token = creator_manage_token
      @visual_snapshot = visual_snapshot
    end

    def call
      attempts = 0

      begin
        attempts += 1
        create_gift
      rescue ActiveRecord::RecordNotUnique
        existing = existing_gift
        return result_for(existing) if existing

        retry if attempts < MAX_COLLISION_ATTEMPTS

        raise
      end
    end

    private

    attr_reader :gift_template, :render_seed, :creation_key, :creator_manage_token, :visual_snapshot

    def create_gift
      Gift.transaction(requires_new: true) do
        existing = existing_gift
        return result_for(existing) if existing

        creator_token = issued_creator_token
        gift = Gift.create!(
          gift_template:,
          public_slug: SecureRandom.urlsafe_base64(12, false),
          state: :discovered,
          render_seed: render_seed || SecureRandom.random_number(2**31),
          creator_manage_token_digest: creator_token.digest,
          creation_key_digest: creation_key_digest,
          visual_configuration: visual_snapshot || GiftVisuals::PrototypeDefault.snapshot_for(gift_template),
          holder_generation: 0,
          discovered_at: Time.current
        )

        Result.new(gift: gift.reload, creator_manage_token: creator_token.raw)
      end
    end

    def existing_gift
      return if creation_key_digest.blank?

      gift = Gift.find_by(creation_key_digest:)
      return unless gift
      raise ActiveRecord::RecordNotUnique unless CapabilityToken.matches?(creator_manage_token, gift.creator_manage_token_digest)

      gift
    end

    def result_for(gift)
      Result.new(gift: gift, creator_manage_token: creator_manage_token)
    end

    def issued_creator_token
      return CapabilityToken.issue if creator_manage_token.blank?

      CapabilityToken::Issued.new(raw: creator_manage_token, digest: CapabilityToken.digest(creator_manage_token))
    end

    def creation_key_digest
      @creation_key_digest ||= CapabilityToken.digest(creation_key) if creation_key.present?
    end
  end
end
