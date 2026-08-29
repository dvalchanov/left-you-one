module Transfers
  class Claim
    Result = Data.define(:status, :gift, :transfer, :journey_stop, :holder_token) do
      def success?
        status == :claimed
      end
    end

    def self.call(raw_token:)
      new(raw_token:).call
    end

    def initialize(raw_token:)
      @raw_token = raw_token.to_s
    end

    def call
      digest = CapabilityToken.digest(raw_token)
      transfer = Transfer.find_by(claim_token_digest: digest)
      return result(:invalid) unless transfer && CapabilityToken.matches?(raw_token, transfer.claim_token_digest)

      Transfer.transaction do
        transfer = Transfer.lock.find(transfer.id)
        gift = Gift.lock.find(transfer.gift_id)

        return result(:already_claimed, gift:, transfer:) if transfer.claimed?
        return result(:invalid, gift:, transfer:) unless transfer.pending? && gift.waiting_for_claim?
        return result(:invalid, gift:, transfer:) unless transfer.source_holder_generation == gift.holder_generation
        return result(:already_claimed, gift:, transfer:) if transfer.journey_stop.present?

        holder = CapabilityToken.issue
        generation = gift.holder_generation + 1
        now = Time.current

        transfer.update!(state: :claimed, claimed_at: now)
        gift.update!(
          state: :held,
          holder_generation: generation,
          current_holder_token_digest: holder.digest,
          opened_by_recipient_at: now
        )
        stop = gift.journey_stops.create!(
          transfer:,
          sequence: generation,
          anonymous: true,
          display_name: transfer.intended_recipient_name.presence,
          arrived_at: now
        )

        result(:claimed, gift:, transfer:, journey_stop: stop, holder_token: holder.raw)
      end
    rescue ActiveRecord::RecordNotUnique
      transfer&.reload
      result(:already_claimed, gift: transfer&.gift, transfer:)
    end

    private

    attr_reader :raw_token

    def result(status, gift: nil, transfer: nil, journey_stop: nil, holder_token: nil)
      Result.new(status:, gift:, transfer:, journey_stop:, holder_token:)
    end
  end
end
