module Gifts
  class ActivateForRecipient
    class InvalidTransition < StandardError; end
    class Unauthorized < StandardError; end

    Result = Data.define(:gift, :transfer, :claim_token, :replaced)

    def self.call(gift:, creator_token:, sender_display_name:, intended_recipient_name:, private_note:, claim_token: nil)
      new(
        gift:,
        creator_token:,
        sender_display_name:,
        intended_recipient_name:,
        private_note:,
        claim_token:
      ).call
    end

    def initialize(gift:, creator_token:, sender_display_name:, intended_recipient_name:, private_note:, claim_token:)
      @gift = gift
      @creator_token = creator_token
      @sender_display_name = normalize(sender_display_name, 200)
      @intended_recipient_name = normalize(intended_recipient_name, 200)
      @private_note = normalize_note(private_note)
      @issued_claim_token = claim_token.present? ? issued(claim_token) : CapabilityToken.issue
    end

    def call
      Gift.transaction do
        gift.lock!
        authorize!
        raise InvalidTransition, gift.state if gift.held?

        current = gift.transfers.pending.lock.first
        return idempotent_result(current) if same_transfer?(current)

        replaced = current.present?
        current&.update!(state: :cancelled, cancelled_at: Time.current)
        transfer = gift.transfers.create!(
          claim_token_digest: issued_claim_token.digest,
          state: :pending,
          sender_display_name:,
          intended_recipient_name:,
          private_note:,
          source_holder_generation: gift.holder_generation
        )

        gift.update!(
          state: :waiting_for_claim,
          origin_name: sender_display_name,
          activated_at: gift.activated_at || Time.current
        )

        Result.new(gift:, transfer:, claim_token: issued_claim_token.raw, replaced:)
      end
    end

    private

    attr_reader :gift, :creator_token, :sender_display_name, :intended_recipient_name,
      :private_note, :issued_claim_token

    def authorize!
      raise Unauthorized unless CapabilityToken.matches?(creator_token, gift.creator_manage_token_digest)
    end

    def same_transfer?(transfer)
      transfer &&
        CapabilityToken.matches?(issued_claim_token.raw, transfer.claim_token_digest) &&
        transfer.sender_display_name == sender_display_name &&
        transfer.intended_recipient_name == intended_recipient_name &&
        transfer.private_note == private_note
    end

    def idempotent_result(transfer)
      Result.new(gift:, transfer:, claim_token: issued_claim_token.raw, replaced: false)
    end

    def issued(raw)
      CapabilityToken::Issued.new(raw:, digest: CapabilityToken.digest(raw))
    end

    def normalize(value, limit)
      value.to_s.strip.gsub(/\s+/, " ").presence&.truncate(limit, omission: "…")
    end

    def normalize_note(value)
      value.to_s.strip.gsub(/\r\n?/, "\n").gsub(/[^\S\n]+/, " ").gsub(/\n{3,}/, "\n\n").presence&.truncate(5_000, omission: "…")
    end
  end
end
