class RemoveUserFromReply < ActiveRecord::Migration[6.0]
  def change
    remove_reference :replies, :user, null: false, foreign_key: true
  end
end