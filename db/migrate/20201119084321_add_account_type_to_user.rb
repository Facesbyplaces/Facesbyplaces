class AddAccountTypeToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :account_type, :integer
  end
end
