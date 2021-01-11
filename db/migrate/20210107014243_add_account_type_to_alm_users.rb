class AddAccountTypeToAlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :alm_users, :guest, :boolean, :default => false
    add_column :alm_users, :account_type, :integer
    add_column :alm_users, :question, :string
    add_column :alm_users, :birthdate, :datetime
    add_column :alm_users, :birthplace, :string
    add_column :alm_users, :address, :string
    add_column :alm_users, :hideBirthdate, :boolean
    add_column :alm_users, :hideBirthplace, :boolean
    add_column :alm_users, :hideEmail, :boolean
    add_column :alm_users, :hideAddress, :boolean
    add_column :alm_users, :hidePhonenumber, :boolean
    add_column :alm_users, :google_id, :string
    add_column :alm_users, :apple_uid, :string
    add_column :alm_users, :facebook_id, :string
  end
end
