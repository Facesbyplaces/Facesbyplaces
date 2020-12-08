class RemoveColumnsFromNotifsettings < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifsettings, :ignore, polymorphic: true, null: false
    remove_reference :notifsettings, :user, null: false, foreign_key: true
  end
end
