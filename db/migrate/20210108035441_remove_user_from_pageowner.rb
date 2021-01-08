class RemoveUserFromPageowner < ActiveRecord::Migration[6.0]
  def change
    remove_reference :pageowners, :user, null: false, foreign_key: true
  end
end
