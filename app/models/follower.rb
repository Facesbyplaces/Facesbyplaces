class Follower < ApplicationRecord
  belongs_to :page, polymorphic: true
  belongs_to :user
end
