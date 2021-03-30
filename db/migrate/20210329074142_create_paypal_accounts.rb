class CreatePaypalAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :paypal_accounts do |t|
      t.string      :paypal_user_id
      t.string      :name
      t.string      :given_name
      t.string      :family_name
      t.string      :payer_id
      t.string      :address, array: true, default: []
      t.boolean     :verified_account
      t.string      :emails
      
      t.references  :paypalable, polymorphic: true

      t.timestamps
    end
  end
end
