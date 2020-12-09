class AddColumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :question, :string, null: true
    add_column :users, :birthdate, :datetime, null: true
    add_column :users, :birthplace, :string, null: true
    add_column :users, :address, :string, null: true
  end
end
