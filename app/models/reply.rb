class Reply < ApplicationRecord
  belongs_to :comment
  belongs_to :account, polymorphic: true
  has_many :commentslikes, as: :commentable

  # Report
  has_many :reports, as: :reportable, dependent: :destroy
end
