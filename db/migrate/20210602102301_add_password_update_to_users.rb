class AddPasswordUpdateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_update, :boolean, :default => false
  end
end
