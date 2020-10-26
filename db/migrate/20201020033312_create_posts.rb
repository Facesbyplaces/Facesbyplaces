class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :user_id
      t.references :memorial, null: false, foreign_key: true
      t.text :body
      t.string :location

      t.timestamps
    end
  end
end
