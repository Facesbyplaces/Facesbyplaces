class RemoveColumnsFromNotifications < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifications, :notify, polymorphic: true, null: false
    remove_reference :notifications, :user, null: false, foreign_key: true
  end
end
