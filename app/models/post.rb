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

  # Search
  include PgSearch::Model
  multisearchable against: [:body, :page_name, :page_location, :page_precinct, :page_state, :page_country, :page_cemetery, :page_birthplace]

  def page_name
    self.page.name
  end

  def page_location
    if self.page_type == 'Blm'
      self.page.location
    else
      ""
    end
  end

  def page_precinct
    if self.page_type == 'Blm'
      self.page.precinct
    else
      ""
    end
  end

  def page_state
    if self.page_type == 'Blm'
      self.page.state
    else
      ""
    end
  end

  def page_country
    self.page.country
  end

  def page_cemetery
    if self.page_type == 'Memorial'
      self.page.cemetery
    else
      ""
    end
  end

  def page_birthplace
    if self.page_type == 'Memorial'
      self.page.birthplace
    else
      ""
    end
  end
end
