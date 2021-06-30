class AddCustomerAccountToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :stripe_customer_account, :string
  end
end
