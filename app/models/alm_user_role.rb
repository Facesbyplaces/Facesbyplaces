class AlmUserRole < ApplicationRecord
  has_and_belongs_to_many :alm_users, :join_table => :alm_users_alm_user_roles
  
  belongs_to :resource,
             :polymorphic => true,
             :optional => true
  

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify
end