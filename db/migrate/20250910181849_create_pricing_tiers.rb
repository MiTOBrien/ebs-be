class CreatePricingTiers < ActiveRecord::Migration[8.0]
  def change
    create_table :pricing_tiers do |t|
      t.integer :word_count
      t.integer :price_cents
      t.string :currency
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
