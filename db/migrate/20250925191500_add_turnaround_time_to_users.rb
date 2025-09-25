class AddTurnaroundTimeToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :turnaround_time, :integer
  end
end
