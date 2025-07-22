class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

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

  def generate_jti
    self.jti = SecureRandom.uuid
  end
end
