class Commentslike < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
end