class AddViewToPageowners < ActiveRecord::Migration[6.0]
  def change
    add_column :pageowners, :view, :integer
  end
end
