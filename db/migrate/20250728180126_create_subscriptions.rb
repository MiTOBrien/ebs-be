class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: true
      t.text :subscription_type, null: false
      t.text :status, default: 'active', null: false
      t.text :stripe_subscription_id
      t.text :stripe_customer_id
      t.datetime :current_period_start
      t.datetime :current_period_end
      t.integer :amount_cents
      t.text :currency, default: 'USD'

      t.timestamps
    end

    add_index :subscriptions, :stripe_subscription_id, unique: true
    add_index :subscriptions, :stripe_customer_id
    add_index :subscriptions, :status

  end
end
