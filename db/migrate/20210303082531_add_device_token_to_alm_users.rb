class AddDeviceTokenToAlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :alm_users, :device_token, :string
  end
end
