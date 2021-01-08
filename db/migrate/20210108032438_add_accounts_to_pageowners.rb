class AddAccountsToPageowners < ActiveRecord::Migration[6.0]
  def change
    add_reference :pageowners, :account, polymorphic: true, null: true
  end
end
