class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles
  validates :role, presence: true, uniqueness: true

  AUTHOR = 'Author'.freeze
  ARC_READER = 'Arc Reader'.freeze
  BETA_READER = 'Beta Reader'.freeze
  PROOFREADER = 'Proof Reader'.freeze
  
  READER_ROLES = [ARC_READER, BETA_READER, PROOFREADER].freeze
end
