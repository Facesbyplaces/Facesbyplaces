class AddAccountToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_reference :transactions, :account, polymorphic: true, null: false
  end
end
