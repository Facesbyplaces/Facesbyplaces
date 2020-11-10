class AddPrivacyToBlms < ActiveRecord::Migration[6.0]
  def change
    add_column :blms, :privacy, :string
  end
end
