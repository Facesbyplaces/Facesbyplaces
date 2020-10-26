class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.integer         :user_id
      t.integer         :memorial_id
      t.integer         :post_id
      t.string          :subject
      t.text            :description
      t.timestamps
    end
  end
end
