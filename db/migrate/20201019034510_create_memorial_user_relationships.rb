class CreateMemorialUserRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :memorial_user_relationships do |t|
      t.integer :user_id, null: false
      t.references :memorial, null: false, foreign_key: true
      t.string :relationship

      t.timestamps
    end
  end
end
