class AddAccountToTagpeople < ActiveRecord::Migration[6.0]
  def change
    add_reference :tagpeople, :account, polymorphic: true, null: true
  end
end
