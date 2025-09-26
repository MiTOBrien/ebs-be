class SetDefaultTurnaroundTimeOnUsers < ActiveRecord::Migration[8.0]
  def up
    # Set default for future records
    change_column_default :users, :turnaround_time, from: nil, to: 0

    # Update existing records with nil to 0
    User.where(turnaround_time: nil).update_all(turnaround_time: 0)
  end

  def down
    # Revert default and allow nulls again
    change_column_default :users, :turnaround_time, from: 0, to: nil
  end
end
