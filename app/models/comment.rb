class Comment < ApplicationRecord
  belongs_to :post
  # Owner of comment
  belongs_to :user
  # replies
  has_many :replies, dependent: :destroy
  has_many :users, through: :replies
  
  has_many :commentslikes, as: :commentable, dependent: :destroy

  # Report
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true
end
