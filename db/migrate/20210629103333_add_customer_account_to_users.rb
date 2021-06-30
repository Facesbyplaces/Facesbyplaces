class AddCustomerAccountToUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :stripe_customer_account, :string
    add_column :users, :platform_account_customer, :string
    add_column :users, :connected_account_customer, :string
  end
end
