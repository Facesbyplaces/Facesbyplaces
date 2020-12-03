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

  # # Search
  # include PgSearch::Model
  # pg_search_scope :search_post,
  #                   against: [:body],
  #                   using: {tsearch: {dictionary: "english"}},
  #                   associated_against: {user: :name, notes:[:title, :content]}
  
  # scope :with_invites_and_access, lambda{ |keywords|
  #   joins("LEFT OUTER JOIN blms ON blms.id = posts.page_id AND posts.page_type = 'Blm'").where('blms.name = :search OR blms.location = :search OR blms.precinct = :search OR blms.state = :search OR blms.country = :search', search: keywords)
  # }

  # def self.text_search(query)
  #   if query.present?
  #     search(query).with_invites_and_access(query)
  #   else
  #     scoped
  #   end
  # end
  
end
