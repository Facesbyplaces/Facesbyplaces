class Blm < ApplicationRecord
  # Active Storage for media uploads
  has_one_attached :backgroundImage
  has_one_attached :profileImage
  has_many_attached :imagesOrVideos

  # Page Owner
  has_one :pageowner, as: :page, dependent: :destroy

  # Current User for Serializer
  def user
    User.first
  end
end
