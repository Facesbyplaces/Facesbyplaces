class Newsletter < ApplicationRecord
    validates_uniqueness_of :email_address
end
