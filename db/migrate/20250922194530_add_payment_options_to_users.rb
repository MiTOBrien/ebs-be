class AddPaymentOptionsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :payment_options, :string
  end
end
