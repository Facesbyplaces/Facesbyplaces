class CreateCommentslikes < ActiveRecord::Migration[6.0]
  def change
    create_table :commentslikes do |t|
      t.references :commentable, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
