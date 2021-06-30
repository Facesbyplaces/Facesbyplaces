class AddCustomerAccountToAlmUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :alm_users, :stripe_customer_account, :string
    add_column :alm_users, :platform_account_customer, :string
    add_column :alm_users, :connected_account_customer, :string
  end
end
