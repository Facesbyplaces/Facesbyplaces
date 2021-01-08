class Postslike < ApplicationRecord
  belongs_to :post
  belongs_to :account, polymorphic: true
end
