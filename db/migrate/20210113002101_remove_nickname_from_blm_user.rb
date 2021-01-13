class RemoveNicknameFromBlmUser < ActiveRecord::Migration[6.0]
  def change
    remove_column :blm_users, :nickname, :string
  end
end
