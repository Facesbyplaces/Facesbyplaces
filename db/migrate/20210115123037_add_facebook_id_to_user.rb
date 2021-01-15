class AddFacebookIdToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :guest, :boolean, :default => false
    add_column :users, :account_type, :integer
    add_column :users, :question, :string
    add_column :users, :birthdate, :datetime
    add_column :users, :birthplace, :string
    add_column :users, :address, :string
    add_column :users, :hideBirthdate, :boolean
    add_column :users, :hideBirthplace, :boolean
    add_column :users, :hideEmail, :boolean
    add_column :users, :hideAddress, :boolean
    add_column :users, :hidePhonenumber, :boolean
    add_column :users, :google_id, :string
    add_column :users, :apple_uid, :string
    add_column :users, :facebook_id, :string
  end
end
