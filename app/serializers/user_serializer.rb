class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :professional, :username, :roles,:bio, :profile_picture, :facebook, :instagram, :x
end
