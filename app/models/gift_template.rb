class GiftTemplate < ApplicationRecord
  THEMES = %w[courage calm momentum connection luck wonder strange].freeze

  has_many :gifts, dependent: :restrict_with_exception

  enum :theme, THEMES.index_with(&:itself), validate: true, prefix: true

  scope :active, -> { where(active: true) }

  validates :source_key, presence: true, uniqueness: true, length: { maximum: 100 }
  validates :main_text, presence: true, length: { maximum: 1_000 }
  validates :context_text, :ritual_text, length: { maximum: 2_000 }, allow_nil: true
  validates :visual_family, :finish, :background_key, length: { maximum: 100 }, allow_nil: true
end
