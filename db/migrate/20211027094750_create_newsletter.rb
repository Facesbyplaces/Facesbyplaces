class CreateNewsletter < ActiveRecord::Migration[6.0]
  def change
    create_table :newsletters do |t|
      t.string      :name
      t.string      :email_address
      t.text        :message
      t.boolean     :have_notified, :default => false
    end
  end
end
