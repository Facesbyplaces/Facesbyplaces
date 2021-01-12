class RemoveNameFromBlmUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :blm_users, :name, :string
  end
end
