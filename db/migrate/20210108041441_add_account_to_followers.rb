class AddAccountToFollowers < ActiveRecord::Migration[6.0]
  def change
    add_reference :followers, :account, polymorphic: true, null: false
  end
end
