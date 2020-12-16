class CreateShares < ActiveRecord::Migration[6.0]
  def change
    create_table :shares do |t|
      t.integer                 :user_id
      t.integer                 :content_type
      t.integer                 :content_type_id

      t.timestamps
    end
  end
end
