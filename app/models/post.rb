class Post < ApplicationRecord
  belongs_to :memorial
  has_many_attached :imagesOrVideos

  # validation
  validates :memorial_id, presence: true
  validates :body, presence: true
  validates :location, presence: true

end
