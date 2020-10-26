class Report < ApplicationRecord
    belongs_to :user
    belongs_to :memorial
    belongs_to :post
end
