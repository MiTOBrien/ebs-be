class PricingTierSerializer
  include JSONAPI::Serializer

  attributes :id, :word_count, :price_cents, :currency
end
