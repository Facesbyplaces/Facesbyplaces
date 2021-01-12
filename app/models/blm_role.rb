class BlmRole < ApplicationRecord
  has_and_belongs_to_many :blm_users, :join_table => :blm_users_blm_roles
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end
