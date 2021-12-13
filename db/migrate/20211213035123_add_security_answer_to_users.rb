class AddSecurityAnswerToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :alm_users, :security_answer, :string
    add_column :users, :security_answer, :string
  end
end
