# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify

  has_many :authorizations
  validates :email, :presence => true
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, omniauth_providers: %i[:facebook, :google_oauth2]
  
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  
  # has_many :pages
  has_many :posts, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_many :notifsettings, dependent: :destroy
  has_one :image

  def self.create_from_provider_data(provider_data)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.new_guest
      new { |u| u.guest = true }
  end
     
  def move_to(user)
       pages.update_all(user_id: user.id)
       posts.update_all(user_id: user.id)
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end

end
