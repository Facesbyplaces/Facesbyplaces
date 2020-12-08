class AddColumnsToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    add_column :notifsettings, :newMemorial, :boolean
    add_column :notifsettings, :newActivities, :boolean
    add_column :notifsettings, :postLikes, :boolean
    add_column :notifsettings, :postComments, :boolean
    add_column :notifsettings, :addFamily, :boolean
    add_column :notifsettings, :addFriends, :boolean
    add_column :notifsettings, :addAdmin, :boolean
  end
end
