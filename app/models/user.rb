# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2]
  
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  
  has_many :pages
  has_many :posts
  has_many :shares
  has_many :followers
  has_many :notifications

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token(0, 20)
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
