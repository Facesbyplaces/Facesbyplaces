class CreateRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :relationships do |t|
      t.references :page, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.string :relationship

      t.timestamps
    end
  end
end
