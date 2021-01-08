class AddAccountToCommentslikes < ActiveRecord::Migration[6.0]
  def change
    add_reference :commentslikes, :account, polymorphic: true, null: false
  end
end
