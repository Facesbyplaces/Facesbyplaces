class AddAccountToPost < ActiveRecord::Migration[6.0]
  def change
    add_reference :posts, :account, polymorphic: true, null: true
  end
end
