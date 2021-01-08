class AddAccountToComments < ActiveRecord::Migration[6.0]
  def change
    add_reference :comments, :account, polymorphic: true, null: false
  end
end
