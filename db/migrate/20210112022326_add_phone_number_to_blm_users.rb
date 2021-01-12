class AddPhoneNumberToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :phone_number, :string
  end
end
