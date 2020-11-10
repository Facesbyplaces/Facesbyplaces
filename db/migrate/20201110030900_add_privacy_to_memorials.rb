class AddPrivacyToMemorials < ActiveRecord::Migration[6.0]
  def change
    add_column :memorials, :privacy, :string
  end
end
