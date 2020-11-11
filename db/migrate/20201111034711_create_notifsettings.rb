class CreateNotifsettings < ActiveRecord::Migration[6.0]
  def change
    create_table :notifsettings do |t|
      t.references :ignore, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
