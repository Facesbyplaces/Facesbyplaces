class Notification < ApplicationRecord
  belongs_to :notify, polymorphic: true
  belongs_to :user
end
