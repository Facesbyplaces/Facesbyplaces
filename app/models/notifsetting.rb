class Notifsetting < ApplicationRecord
  belongs_to :ignore, polymorphic: true
  belongs_to :user
end
