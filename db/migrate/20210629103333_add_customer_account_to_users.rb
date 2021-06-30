class AddCustomerAccountToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :platform_account_customer, :string
    remove_column :users, :connected_account_customer, :string
    add_column :users, :platform_account_customer, :string
    add_column :users, :connected_account_customer, :string
  end
end
