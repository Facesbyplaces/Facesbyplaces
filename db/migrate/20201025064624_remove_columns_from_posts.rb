class RemoveColumnsFromPosts < ActiveRecord::Migration[6.0]
  def change
    remove_column :posts, :user_id, :integer
    remove_reference :posts, :memorial, null: false, foreign_key: true
  end
end
