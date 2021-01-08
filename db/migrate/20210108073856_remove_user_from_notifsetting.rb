class RemoveUserFromNotifsetting < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifsettings, :user, null: false, foreign_key: true
  end
end
