class Memorial < ApplicationRecord
    # media upload for creating memorial
    has_one_attached :backgroundImage
    has_one_attached :profileImage
    has_many_attached :imagesOrVideos

    # Page Owner
    has_one :pageowner, as: :page, dependent: :destroy
  
    # Relationship of pages and users
    has_many :relationships, as: :page, dependent: :destroy
  
    # Posts of this page
    has_many :posts, as: :page, dependent: :destroy

    # Reports of this page
    has_many :reports, as: :page, dependent: :destroy

    # Followers of this page
    has_many :followers, as: :page, dependent: :destroy
    has_many :users, through: :followers

    resourcify

    # page name
    def page_name
        "memorial"
    end
    
end
