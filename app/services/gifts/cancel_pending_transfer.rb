module Gifts
  class CancelPendingTransfer
    class Unauthorized < StandardError; end
    class InvalidTransition < StandardError; end

    def self.call(gift:, creator_token:)
      new(gift:, creator_token:).call
    end

    def initialize(gift:, creator_token:)
      @gift = gift
      @creator_token = creator_token
    end

    def call
      Gift.transaction do
        gift.lock!
        raise Unauthorized unless CapabilityToken.matches?(creator_token, gift.creator_manage_token_digest)
        raise InvalidTransition unless gift.waiting_for_claim?

        transfer = gift.transfers.pending.lock.first
        raise InvalidTransition unless transfer

        transfer.update!(state: :cancelled, cancelled_at: Time.current)
        gift.update!(state: :discovered, activated_at: nil, origin_name: nil)
        transfer
      end
    end

    private

    attr_reader :gift, :creator_token
  end
end
