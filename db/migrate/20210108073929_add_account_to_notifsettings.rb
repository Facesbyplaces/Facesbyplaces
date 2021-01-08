class AddAccountToNotifsettings < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifsettings, :account, polymorphic: true, null: true
  end
end
