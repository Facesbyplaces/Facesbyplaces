class RemoveUrlFromNotification < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :url, :string
  end
end
