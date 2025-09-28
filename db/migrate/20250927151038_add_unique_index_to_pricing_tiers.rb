class AddUniqueIndexToPricingTiers < ActiveRecord::Migration[8.0]
  def change
    add_index :pricing_tiers, [:user_id, :word_count, :price_cents, :currency], unique: true, name: 'index_pricing_tiers_on_user_and_details'
  end
end
