class RolifyCreateAlmRoles < ActiveRecord::Migration[6.0]
  def change
    create_table(:alm_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:alm_users_alm_roles, :id => false) do |t|
      t.references :alm_user
      t.references :alm_role
    end
    
    add_index(:alm_roles, :name)
    add_index(:alm_roles, [ :name, :resource_type, :resource_id ])
    add_index(:alm_users_alm_roles, [ :alm_user_id, :alm_role_id ])
  end
end
