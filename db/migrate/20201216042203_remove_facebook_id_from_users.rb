class RemoveFacebookIdFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :facebook_id, :string
  end
end
