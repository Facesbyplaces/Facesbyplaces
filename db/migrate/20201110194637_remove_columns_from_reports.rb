class RemoveColumnsFromReports < ActiveRecord::Migration[6.0]
  def change
    remove_column :reports, :user_id, :integer
    remove_column :reports, :memorial_id, :integer
    remove_column :reports, :post_id, :integer
    remove_reference :reports, :page, polymorphic: true, null: false
  end
end
