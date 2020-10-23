class Memorial < ApplicationRecord
    has_many :memorialUserRelationships, dependent: :destroy
    has_many :posts, dependent: :destroy
    has_many :report
    belongs_to :user

    # media upload for creating memorial
    has_one_attached :backgroundImage
    has_one_attached :profileImage
    has_many_attached :imagesOrVideos

    # user id for the serializer
    def user_id
        User.first.id
    end
end
