class RemoveReferencesToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifsettings, :ignore, polymorphic: true, null: false if Notifsetting.column_names.include?('ignore')
    remove_reference :notifsettings, :user, null: false, foreign_key: true if Notifsetting.column_names.include?('user')
  end
end
