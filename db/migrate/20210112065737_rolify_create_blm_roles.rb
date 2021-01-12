class RolifyCreateBlmRoles < ActiveRecord::Migration[6.0]
  def change
    create_table(:blm_roles) do |t|
      t.string :name
      t.references :resource, :polymorphic => true

      t.timestamps
    end

    create_table(:blm_users_blm_roles, :id => false) do |t|
      t.references :blm_user
      t.references :blm_role
    end
    
    add_index(:blm_roles, :name)
    add_index(:blm_roles, [ :name, :resource_type, :resource_id ])
    add_index(:blm_users_blm_roles, [ :blm_user_id, :blm_role_id ])
  end
end
