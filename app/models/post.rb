class Post < ApplicationRecord
  belongs_to        :page, polymorphic: true
  belongs_to        :user
  has_many_attached :imagesOrVideos
  has_many          :report

  # validation
  validates :body, presence: true
  validates :location, presence: true

  # if self.page_type == "Blm"
  #   belongs_to :page_data, -> { where( posts: { page_type: 'Blm' } ).includes( :posts ) }, foreign_key: 'page_id'
  # else
  #   belongs_to :page_data, -> { where( posts: { page_type: 'Memorial' } ).includes( :posts ) }, foreign_key: 'page_id'
  # end

end
