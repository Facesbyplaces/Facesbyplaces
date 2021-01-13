class ChangeColumnToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :blm_users, :is_verified, :boolean, :default => false
  end
end
