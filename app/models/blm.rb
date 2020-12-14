class Blm < ApplicationRecord
  # Active Storage for media uploads
  has_one_attached :backgroundImage
  has_one_attached :profileImage
  has_many_attached :imagesOrVideos

  # Page Owner
  has_one :pageowner, as: :page, dependent: :destroy

  # Relationship of pages and users
  has_many :relationships, as: :page, dependent: :destroy
  has_many :familiesAndFriends, foreign_key: "user_id", class_name: "Relationship"

  # Posts of this page
  has_many :posts, as: :page, dependent: :destroy

  #Reports of this page
  has_many :reports, as: :page, dependent: :destroy

  # Followers of this page
  has_many :followers, as: :page, dependent: :destroy
  has_many :users, through: :followers

  # Report
  has_many :reports, as: :reportable, dependent: :destroy

  # Transactions
  has_many :transactions, as: :page, dependent: :destroy

  resourcify

  # geocdoe
  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  # Search
  include PgSearch::Model
  multisearchable against: [:name, :location, :precinct, :state, :country]

  # page name
  def page_name
      "blm"
  end
end
