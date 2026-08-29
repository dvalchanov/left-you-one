class Transfer < ApplicationRecord
  STATES = %w[pending claimed cancelled].freeze
  TOKEN_DIGEST_FORMAT = /\A[0-9a-f]{64}\z/

  belongs_to :gift
  has_one :journey_stop, dependent: :restrict_with_exception

  enum :state, STATES.index_with(&:itself), validate: true

  validates :claim_token_digest, presence: true, uniqueness: true,
    format: { with: TOKEN_DIGEST_FORMAT }
  validates :gift_id,
    uniqueness: { conditions: -> { where(state: "pending") }, message: "already has a pending transfer" },
    if: :pending?
  validates :source_holder_generation,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :sender_display_name, :intended_recipient_name, presence: true, length: { maximum: 200 }
  validates :private_note, length: { maximum: 5_000 }, allow_nil: true

  def serializable_hash(options = nil)
    options = (options || {}).dup
    options[:except] = Array(options[:except]) | [ "private_note" ]
    super(options)
  end
end
