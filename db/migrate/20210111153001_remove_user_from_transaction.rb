class RemoveUserFromTransaction < ActiveRecord::Migration[6.0]
  def change
    remove_reference :transactions, :user, null: false, foreign_key: true
  end
end
