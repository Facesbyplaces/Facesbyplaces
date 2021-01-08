class Commentslike < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :account, polymorphic: true
end
