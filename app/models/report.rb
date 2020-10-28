class Report < ApplicationRecord
    belongs_to :page, polymorphic: true
    belongs_to :user
    belongs_to :post
end
