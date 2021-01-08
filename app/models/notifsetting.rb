class Notifsetting < ApplicationRecord
  belongs_to :account, polymorphic: true
end
