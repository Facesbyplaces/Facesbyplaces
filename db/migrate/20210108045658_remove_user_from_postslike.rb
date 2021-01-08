class RemoveUserFromPostslike < ActiveRecord::Migration[6.0]
  def change
    remove_reference :postslikes, :user, null: false, foreign_key: true
  end
end
