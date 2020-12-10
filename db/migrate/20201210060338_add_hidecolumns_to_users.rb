class AddHidecolumnsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :hideBirthdate, :boolean, null: true
    add_column :users, :hideBirthplace, :boolean, null: true
    add_column :users, :hideEmail, :boolean, null: true
    add_column :users, :hideAddress, :boolean, null: true
    add_column :users, :hidePhonenumber, :boolean, null: true
  end
end
