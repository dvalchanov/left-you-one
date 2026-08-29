class JourneyStop < ApplicationRecord
  belongs_to :gift
  belongs_to :transfer, optional: true

  validates :sequence,
    presence: true,
    numericality: { only_integer: true, greater_than: 0 },
    uniqueness: { scope: :gift_id }
  validates :transfer_id, uniqueness: true, allow_nil: true
  validates :arrived_at, presence: true
  validates :display_name, :city, length: { maximum: 200 }, allow_nil: true
  validates :country_code,
    format: { with: /\A[A-Z]{2}\z/, message: "must be a two-letter uppercase code" },
    allow_nil: true
end
