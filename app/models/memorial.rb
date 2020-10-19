class Memorial < ApplicationRecord
    has_many :memorialUserRelationships

    # media upload for creating memorial
    has_one_attached :backgroundImage
    has_one_attached :profileImage
    has_many_attached :imagesOrVideos


end
