class CreateMemorialUserRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :memorial_user_relationships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :memorial, null: false, foreign_key: true
      t.string :relationship

      t.timestamps
    end
  end
end
