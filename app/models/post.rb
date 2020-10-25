class Post < ApplicationRecord
  belongs_to :page, polymorphic: true
  belongs_to :user
  has_many_attached :imagesOrVideos
  has_many :report

  # validation
  validates :body, presence: true
  validates :location, presence: true

end
