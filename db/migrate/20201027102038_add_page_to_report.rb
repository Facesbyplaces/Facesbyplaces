class AddPageToReport < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :page_type, :string
    add_column :reports, :page_id, :integer 
  end
end
