# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify

  has_many :authorizations
  # validates :email, :presence => true, unless: :guest?
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :apple]
  
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  devise :omniauthable, omniauth_providers: [:facebook, :google_oauth2, :apple]
  
  # has_many :pages
  has_many :posts, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_one :notifsetting, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_many :relationships

  # Transactions
  has_many :transactions, dependent: :destroy

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def self.create_from_provider_data(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
    end
  end

  def self.register_user_from_apple(email, uid)
    User.create do |user|
      user.apple_uid = uid
      user.email = email
      user.provider = :apple # devise_token_auth attribute, but you can add it yourself.
      user.uid = email # devise_token_auth attribute
    end
  end

  def self.new_guest
      new { |u| u.guest = true }
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end

end
