class RemoveUserIdFromMemorialUserRelationships < ActiveRecord::Migration[6.0]
  def change
    remove_column :memorial_user_relationships, :user_id, :integer
  end
end
