class CleanUpUserFields < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :charges_for_services, :boolean
    remove_column :users, :professional, :boolean
  end
end
