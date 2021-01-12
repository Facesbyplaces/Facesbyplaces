class AddUsernameToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :username, :string
  end
end
