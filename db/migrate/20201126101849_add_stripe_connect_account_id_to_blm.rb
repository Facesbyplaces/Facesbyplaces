class AddStripeConnectAccountIdToBlm < ActiveRecord::Migration[6.0]
  def change
    add_column :blms, :stripe_connect_account_id, :string
  end
end
