class AddUserToMemorialUserRelationships < ActiveRecord::Migration[6.0]
  def change
    add_reference :memorial_user_relationships, :user, null: false, foreign_key: true
  end
end
