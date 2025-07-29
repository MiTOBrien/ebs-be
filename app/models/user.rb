class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :subscriptions, dependent: :destroy
  has_one :current_subscription, -> { where(status: 'active') }, class_name: 'Subscription'
  
  # Add validation
  validates :subscription_type, inclusion: { in: %w[free monthly annual] }
  validates :subscription_status, inclusion: { in: %w[active cancelled past_due incomplete] }
  
  before_validation :set_subscription_defaults, on: :create

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles

  has_many :user_genres, dependent: :destroy
  has_many :genres, through: :user_genres

  # def role_names=(names)
  #   self.roles = names.map { |name| Role.find_by(name: name) }.compact
  # end

  def role_names
    roles.pluck(:role)
  end

  # Required for self revocation strategy
  def self.jwt_revoked?(payload, user)
    user.jti != payload['jti']
  end

  def self.revoke_jwt(payload, user)
    user.update_column(:jti, SecureRandom.uuid)
  end

  # Generate jti on user creation
  before_create :generate_jti

  private

  def set_subscription_defaults
    self.charges_for_services ||= false
    self.subscription_type ||= 'free'
    self.subscription_status ||= 'active'
  end

  def generate_jti
    self.jti = SecureRandom.uuid
  end
end