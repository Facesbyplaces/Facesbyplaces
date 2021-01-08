class RemoveUserFromTagperson < ActiveRecord::Migration[6.0]
  def change
    remove_reference :tagpeople, :user, null: false, foreign_key: true
  end
end
