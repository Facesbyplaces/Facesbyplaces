class RemoveReferencesToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifsettings, :ignore, polymorphic: true, null: false if Notifsetting.column_names.include?('ignore_id')
    remove_reference :notifsettings, :user, null: false, foreign_key: true if Notifsetting.column_names.include?('user_id')
  end
end