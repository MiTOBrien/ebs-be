class SetDefaultAndNotNullForDisabledOnUsers < ActiveRecord::Migration[8.0]
  def up
    # Set default for future records
    change_column_default :users, :disabled, from: nil, to: false

    # Update existing records
    User.where(disabled: nil).update_all(disabled: false)

    # Enforce NOT NULL constraint
    change_column_null :users, :disabled, false
  end

  def down
    change_column_null :users, :disabled, true
    change_column_default :users, :disabled, from: false, to: nil
  end
end
