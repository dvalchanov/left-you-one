require "digest"
require "securerandom"

class CapabilityToken
  BYTE_LENGTH = 32
  Issued = Data.define(:raw, :digest)

  def self.issue
    raw = SecureRandom.urlsafe_base64(BYTE_LENGTH, false)
    Issued.new(raw:, digest: digest(raw))
  end

  def self.digest(raw_token)
    Digest::SHA256.hexdigest(raw_token)
  end

  def self.matches?(raw_token, stored_digest)
    return false if raw_token.blank? || stored_digest.blank?

    candidate = digest(raw_token)
    stored = stored_digest.to_s
    candidate.bytesize == stored.bytesize && ActiveSupport::SecurityUtils.secure_compare(candidate, stored)
  end
end
