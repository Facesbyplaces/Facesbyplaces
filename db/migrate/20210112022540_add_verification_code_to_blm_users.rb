class AddVerificationCodeToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :verification_code, :integer
  end
end
