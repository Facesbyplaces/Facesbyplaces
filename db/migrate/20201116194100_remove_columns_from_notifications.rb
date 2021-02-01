class RemoveColumnsFromNotifications < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifications, :notify, polymorphic: true, null: false
  end
end
