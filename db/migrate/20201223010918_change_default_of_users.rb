class ChangeDefaultOfUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :is_verified, :boolean, :default => nil
  end
end
