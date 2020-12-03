class CreateImages < ActiveRecord::Migration[6.0]
  def change
    create_table :images do |t|
      t.integer         :user_id
      t.string          :image
      t.timestamps
    end
  end
end
