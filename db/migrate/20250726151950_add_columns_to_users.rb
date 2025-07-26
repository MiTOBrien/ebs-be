class AddColumnsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :username, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :x, :string
  end
end
