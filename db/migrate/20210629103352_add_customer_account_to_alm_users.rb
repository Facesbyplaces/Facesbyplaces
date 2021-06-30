class AddCustomerAccountToAlmUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :alm_users, :stripe_customer_account, :string
  end
end
