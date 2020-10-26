class AddColumnToBlms < ActiveRecord::Migration[6.0]
  def change
    add_column :blms, :name, :string
    add_column :blms, :description, :text
  end
end
