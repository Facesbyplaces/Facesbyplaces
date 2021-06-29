class AddPasswordUpdateToAlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :alm_users, :password_update, :boolean, :default => false
  end
end
