class AddColumnsToBlms < ActiveRecord::Migration[6.0]
  def change
    add_column :blms, :hideFamily, :boolean
    add_column :blms, :hideFriends, :boolean
    add_column :blms, :hideFollowers, :boolean
  end
end
