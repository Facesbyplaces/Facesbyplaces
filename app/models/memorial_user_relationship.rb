class MemorialUserRelationship < ApplicationRecord
  belongs_to :user
  belongs_to :memorial
end
