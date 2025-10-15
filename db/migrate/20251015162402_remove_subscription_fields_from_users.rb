class RemoveSubscriptionFieldsFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :subscription_type, :text
    remove_column :users, :subscription_status, :text
  end
end