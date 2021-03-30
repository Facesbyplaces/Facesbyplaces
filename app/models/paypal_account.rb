class PaypalAccount < ApplicationRecord
    belongs_to :paypalable, polymorphic: true
end
