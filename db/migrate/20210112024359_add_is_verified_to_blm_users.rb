class AddIsVerifiedToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :is_verified, :boolean
  end
end
