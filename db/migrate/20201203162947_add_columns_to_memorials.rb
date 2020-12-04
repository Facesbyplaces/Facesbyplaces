class AddColumnsToMemorials < ActiveRecord::Migration[6.0]
  def change
    add_column :memorials, :hideFamily, :boolean
    add_column :memorials, :hideFriends, :boolean
    add_column :memorials, :hideFollowers, :boolean
  end
end
