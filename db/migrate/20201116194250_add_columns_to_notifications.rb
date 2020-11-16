class AddColumnsToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :recipient_id, :integer
    add_column :notifications, :actor_id, :integer
    add_column :notifications, :read, :boolean
    add_column :notifications, :action, :string
    add_column :notifications, :url, :string
  end
end
