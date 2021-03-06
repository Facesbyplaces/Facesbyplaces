class Comment < ApplicationRecord
  belongs_to :post
  # Owner of comment
  belongs_to :account, polymorphic: true
  # replies
  has_many :replies, dependent: :destroy
  has_many :accounts, through: :replies
  
  has_many :commentslikes, as: :commentable, dependent: :destroy

  # Report
  has_many :reports, as: :reportable, dependent: :destroy

  validates :body, presence: true
  # Search
  include PgSearch::Model
  # pg_search_scope :search_by_text, against: :body
  multisearchable against: [:body]
end
