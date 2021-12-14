class AddDeletableToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :deletable, :boolean, :default => false
  end
end
