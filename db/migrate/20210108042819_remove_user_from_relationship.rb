class RemoveUserFromRelationship < ActiveRecord::Migration[6.0]
  def change
    remove_reference :relationships, :user, null: false, foreign_key: true
  end
end
