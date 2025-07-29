class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :professional, :username, :bio, :profile_picture, :facebook, :instagram, :x

  attribute :roles do |user|
    user.user_roles.includes(:role).map(&:role)
  end
end
