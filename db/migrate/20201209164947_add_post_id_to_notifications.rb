class AddPostIdToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_column :notifications, :postId, :integer, null: true
  end
end
