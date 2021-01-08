class AddAccountToReplies < ActiveRecord::Migration[6.0]
  def change
    add_reference :replies, :account, polymorphic: true, null: false
  end
end
