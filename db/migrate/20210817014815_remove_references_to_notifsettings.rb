class RemoveReferencesToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifsettings, :ignore, polymorphic: true, null: false if Notifsetting.column_names.include?('ignore_id')
    remove_reference :notifsettings, :user, null: false, foreign_key: true if Notifsetting.column_names.include?('user_id')
    remove_column :memorials, :user_id, :integer if Memorial.column_names.include?('user_id')
    remove_column :blms, :user_id, :integer if Blm.column_names.include?('user_id')
    remove_column :pageowners, :user_id, :integer if Pageowner.column_names.include?('user_id')
    remove_column :relationships, :user_id, :integer if Relationship.column_names.include?('user_id')
    remove_reference :notifications, :notify, polymorphic: true, null: false if Notification.column_names.include?('notify_id')
    remove_reference :notifications, :user, null: false, foreign_key: true if Notification.column_names.include?('user_id')
    remove_reference :posts, :memorial, null: false, foreign_key: true if Post.column_names.include?('memorial_id')
    remove_column :posts, :user_id, :integer if Post.column_names.include?('user_id')
  end
end
