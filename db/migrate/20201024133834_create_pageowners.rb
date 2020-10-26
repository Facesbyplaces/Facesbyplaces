class CreatePageowners < ActiveRecord::Migration[6.0]
  def change
    create_table :pageowners do |t|
      t.references :user, null: false, foreign_key: true
      t.references :page, polymorphic: true, null: false

      t.timestamps
    end
  end
end
