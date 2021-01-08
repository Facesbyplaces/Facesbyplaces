class RemoveUserFromFollower < ActiveRecord::Migration[6.0]
  def change
    remove_reference :followers, :user, null: false, foreign_key: true
  end
end
