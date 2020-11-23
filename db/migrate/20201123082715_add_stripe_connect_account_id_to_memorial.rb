class AddStripeConnectAccountIdToMemorial < ActiveRecord::Migration[6.0]
  def change
    add_column :memorials, :stripe_connect_account_id, :string
  end
end
