class AddColumnsToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :guest, :boolean, :default => false
    add_column :blm_users, :account_type, :integer
    add_column :blm_users, :question, :string
    add_column :blm_users, :birthdate, :datetime
    add_column :blm_users, :birthplace, :string
    add_column :blm_users, :address, :string
    add_column :blm_users, :hideBirthdate, :boolean
    add_column :blm_users, :hideBirthplace, :boolean
    add_column :blm_users, :hideEmail, :boolean
    add_column :blm_users, :hideAddress, :boolean
    add_column :blm_users, :hidePhonenumber, :boolean
    add_column :blm_users, :google_id, :string
    add_column :blm_users, :apple_uid, :string
    add_column :blm_users, :facebook_id, :string
  end
end
