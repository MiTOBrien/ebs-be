class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :professional, :username, :bio, :profile_picture, :facebook, :instagram, :x

  attribute :roles do |user|
    user.user_roles.includes(:role).map(&:role)
  end

  attribute :genres do |user|
    user.user_genres.includes(genre: :subgenres).map do |user_genre|
      genre = user_genre.genre
      {
        id: genre.id,
        name: genre.name,
        subgenres: genre.subgenres.map do |sub|
          {
            id: sub.id,
            name: sub.name,
            parent_id: genre.id
          }
        end
      }
    end
  end
end
