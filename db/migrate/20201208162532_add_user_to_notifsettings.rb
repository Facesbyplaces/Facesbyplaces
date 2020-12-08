class AddUserToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifsettings, :user, null: false, foreign_key: true
  end
end
