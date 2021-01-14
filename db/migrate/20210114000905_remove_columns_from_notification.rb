class RemoveColumnsFromNotification < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :recipient_id, :integer
    remove_column :notifications, :actor_id, :integer
  end
end
