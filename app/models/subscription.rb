class Subscription < ApplicationRecord
  belongs_to :user
  
  validates :subscription_type, inclusion: { in: %w[month year lifetime] }
  validates :status, inclusion: { in: %w[active cancelled past_due incomplete] }
end