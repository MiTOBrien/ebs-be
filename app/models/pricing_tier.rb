class PricingTier < ApplicationRecord
  belongs_to :user

  validates :word_count, numericality: { greater_than: 0 }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
end