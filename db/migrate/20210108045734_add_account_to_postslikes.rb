class AddAccountToPostslikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :postslikes, :account, polymorphic: true, null: true
  end
end
