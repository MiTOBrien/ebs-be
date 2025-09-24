class ChangePaymentOptionsToJsonb < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :payment_options, :string
    add_column :users, :payment_options, :jsonb, default: [], null: false
  end
end
