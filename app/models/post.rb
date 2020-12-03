class Post < ApplicationRecord
  belongs_to        :page, polymorphic: true
  belongs_to        :user
  has_many_attached :imagesOrVideos
  has_many          :comments, dependent: :destroy
  has_many          :postslikes, dependent: :destroy

  # tagging people
  has_many :tagpeople, dependent: :destroy
  has_many :users, through: :tagpeople

  # Report
  has_many :reports, as: :reportable, dependent: :destroy

  # validation
  validates :body, presence: true
  validates :location, presence: true

  # Search
  include PgSearch::Model
  pg_search_scope :search_post, against: :body
  
end
