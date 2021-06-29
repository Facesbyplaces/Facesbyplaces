class AddPasswordUpdateToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :password_update, :boolean, :default => false
    add_column :users, :stripe_customer_account, :string
  end
end
