class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :page, polymorphic: true, null: false
      t.references :user, null: false, foreign_key: true
      t.float :amount

      t.timestamps
    end
  end
end
