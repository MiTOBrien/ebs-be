class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :first_name, :last_name, :professional, :username, :bio, :profile_picture, :charges_for_services, :facebook, :instagram, :x, :disabled, :payment_options

  attribute :roles do |user|
    user.user_roles.includes(:role).map(&:role)
  end

  attribute :pricing_tiers do |user|
    user.pricing_tiers.map do |tier|
      {
        id: tier.id,
        word_count: tier.word_count,
        price_cents: tier.price_cents,
        currency: tier.currency
      }
    end
  end

  attribute :genres do |user|
    # Get all genres the user selected
    selected_genres = user.user_genres.includes(:genre).map(&:genre)

    # Group by parent_id
    top_level = selected_genres.select { |g| g.parent_id.nil? }
    subgenre_map = selected_genres.group_by(&:parent_id)

    top_level.map do |genre|
      {
        id: genre.id,
        name: genre.name,
        subgenres: (subgenre_map[genre.id] || []).map do |sub|
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
