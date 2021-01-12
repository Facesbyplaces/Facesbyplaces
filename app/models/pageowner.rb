class Pageowner < ApplicationRecord
  belongs_to :account, polymorphic: true
  belongs_to :page, polymorphic: true
end
