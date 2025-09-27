class AddHideNameToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :hide_name, :boolean, default: false, null: false
  end
end
