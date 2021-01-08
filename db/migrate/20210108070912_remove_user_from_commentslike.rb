class RemoveUserFromCommentslike < ActiveRecord::Migration[6.0]
  def change
    remove_reference :commentslikes, :user, null: false, foreign_key: true
  end
end
