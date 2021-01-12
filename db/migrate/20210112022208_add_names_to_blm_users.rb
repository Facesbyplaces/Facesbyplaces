class AddNamesToBlmUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :blm_users, :first_name, :string
    add_column :blm_users, :last_name, :string
  end
end
