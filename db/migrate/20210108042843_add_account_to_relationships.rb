class AddAccountToRelationships < ActiveRecord::Migration[6.0]
  def change
    add_reference :relationships, :account, polymorphic: true, null: true
  end
end
