class AddSubscriptionToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :charges_for_services, :boolean, default: false, null: false
    add_column :users, :subscription_type, :text, default: 'free', null: false
    add_column :users, :subscription_status, :text, default: 'active', null: false

    add_index :users, :subscription_type
    add_index :users, :subscription_status
  end
end
