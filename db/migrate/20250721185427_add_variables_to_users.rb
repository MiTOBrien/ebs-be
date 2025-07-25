class AddVariablesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :username, :string
    add_column :users, :professional, :boolean
    add_column :users, :acknowledgement, :boolean
    add_column :users, :bio, :text
    add_column :users, :profile_picture, :string
    add_column :users, :facebook, :string
    add_column :users, :instagram, :string
    add_column :users, :x, :string
  end
end
