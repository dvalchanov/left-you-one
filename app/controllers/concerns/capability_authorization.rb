module CapabilityAuthorization
  extend ActiveSupport::Concern

  private

  def creator_token_for(gift)
    payload = encrypted_cookie(:creator_access)
    return unless payload["gift_id"].to_i == gift.id

    token = payload["token"].to_s
    token if CapabilityToken.matches?(token, gift.creator_manage_token_digest)
  end

  def holder_access_for(gift)
    payload = encrypted_cookie(:holder_access)
    return {} unless payload["gift_id"].to_i == gift.id
    return {} unless payload["holder_generation"].to_i == gift.holder_generation
    return {} unless CapabilityToken.matches?(payload["token"], gift.current_holder_token_digest)

    payload
  end

  def gift_draft_for(gift)
    payload = encrypted_cookie(:gift_draft)
    payload["gift_id"].to_i == gift.id ? payload : {}
  end

  def pending_claim_access_for(gift)
    payload = encrypted_cookie(:pending_claim_access)
    return {} unless payload["gift_id"].to_i == gift.id

    transfer = gift.transfers.find_by(id: payload["transfer_id"])
    return {} unless transfer&.pending?
    return {} unless CapabilityToken.matches?(payload["token"], transfer.claim_token_digest)

    payload
  end

  def write_creator_access(gift, token)
    write_encrypted_cookie(:creator_access, { gift_id: gift.id, token: }, expires: 30.days)
  end

  def write_holder_access(gift, token)
    write_encrypted_cookie(
      :holder_access,
      { gift_id: gift.id, holder_generation: gift.holder_generation, token: },
      expires: 30.days
    )
  end

  def write_gift_draft(gift, attributes)
    write_encrypted_cookie(:gift_draft, attributes.merge(gift_id: gift.id), expires: 2.days)
  end

  def write_pending_claim_access(gift, transfer, token)
    write_encrypted_cookie(
      :pending_claim_access,
      { gift_id: gift.id, transfer_id: transfer.id, token: },
      expires: 14.days
    )
  end

  def clear_gift_draft
    cookies.delete(:gift_draft)
  end

  def clear_pending_claim_access
    cookies.delete(:pending_claim_access)
  end

  def encrypted_cookie(name)
    value = cookies.encrypted[name]
    value.is_a?(Hash) ? value.stringify_keys : {}
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    {}
  end

  def write_encrypted_cookie(name, value, expires:)
    cookies.encrypted[name] = {
      value: value,
      expires:,
      httponly: true,
      same_site: :lax,
      secure: request.ssl?
    }
  end

  def set_private_response_headers
    response.set_header("Referrer-Policy", "no-referrer")
    response.set_header("X-Robots-Tag", "noindex, nofollow, noarchive")
    response.set_header("Cache-Control", "private, no-store")
  end
end
