class Gift < ApplicationRecord
  STATES = %w[discovered waiting_for_claim held].freeze
  TOKEN_DIGEST_FORMAT = /\A[0-9a-f]{64}\z/

  belongs_to :gift_template
  has_many :transfers, dependent: :restrict_with_exception
  has_many :journey_stops, dependent: :restrict_with_exception

  enum :state, STATES.index_with(&:itself), validate: true

  validates :serial_number, uniqueness: true, allow_nil: true
  validates :public_slug, presence: true, uniqueness: true,
    format: { with: /\A[A-Za-z0-9_-]{16,}\z/ }
  validates :render_seed, :discovered_at, presence: true
  validates :holder_generation, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :origin_name, length: { maximum: 200 }, allow_nil: true
  validates :creator_manage_token_digest, :current_holder_token_digest, :creation_key_digest,
    uniqueness: true,
    format: { with: TOKEN_DIGEST_FORMAT },
    allow_nil: true
  validate :visual_configuration_must_be_an_object

  def display_serial_number
    format("#%06d", serial_number)
  end

  def pending_transfer
    transfers.pending.order(:created_at).last
  end

  def current_journey_stop
    journey_stops.order(sequence: :desc).first
  end

  private

  def visual_configuration_must_be_an_object
    errors.add(:visual_configuration, "must be an object") unless visual_configuration.is_a?(Hash)
  end
end
