class RenameAcknowledgementToTosAccepted < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :acknowledgement, :tos_accepted
  end
end
