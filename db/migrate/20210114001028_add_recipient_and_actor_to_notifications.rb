class AddRecipientAndActorToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :recipient, polymorphic: true, null: false
    add_reference :notifications, :actor, polymorphic: true, null: false
  end
end
