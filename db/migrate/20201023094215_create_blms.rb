class CreateBlms < ActiveRecord::Migration[6.0]
  def change
    create_table :blms do |t|
      t.string :location
      t.string :precinct
      t.datetime :dob
      t.datetime :rip
      t.string :country
      t.string :state
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
