class AddCoordinatesToBlms < ActiveRecord::Migration[6.0]
  def change
    add_column :blms, :longitude, :float, null: true
    add_column :blms, :latitude, :float, null: true
  end
end
