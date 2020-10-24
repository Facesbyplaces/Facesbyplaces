class Blm < ApplicationRecord
  # Active Storage for media uploads
  has_one_attached :backgroundImage
  has_one_attached :profileImage
  has_many_attached :imagesOrVideos

  
end
