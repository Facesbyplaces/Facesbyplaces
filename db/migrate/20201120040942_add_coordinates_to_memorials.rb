class AddCoordinatesToMemorials < ActiveRecord::Migration[6.0]
  def change
    add_column :memorials, :longitude, :float, null: true
    add_column :memorials, :latitude, :float, null: true
  end
end
