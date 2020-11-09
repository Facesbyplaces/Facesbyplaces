class Post < ApplicationRecord
  belongs_to        :page, polymorphic: true
  belongs_to        :user
  has_many_attached :imagesOrVideos
  has_many          :report
  has_many          :comments
  has_many          :postslikes

  # tagging people
  has_many :tagpeople
  has_many :users, through: :tagpeople

  # validation
  validates :body, presence: true
  validates :location, presence: true

end
