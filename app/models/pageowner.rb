class Pageowner < ApplicationRecord
  belongs_to :user
  belongs_to :page, polymorphic: true
end