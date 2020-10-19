class CreateMemorials < ActiveRecord::Migration[6.0]
  def change
    create_table :memorials do |t|
      t.string :birthplace
      t.datetime :dob
      t.datetime :rip
      t.string :cemetery
      t.string :country
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
