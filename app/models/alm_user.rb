# frozen_string_literal: true

class AlmUser < ActiveRecord::Base
  rolify

  has_many :authorizations

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  
  # has_many :pages
  has_many :posts, dependent: :destroy
  has_many :shares, dependent: :destroy
  has_many :followers, dependent: :destroy
  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_one :notifsetting, dependent: :destroy
  has_one_attached :image, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :pageowners, dependent: :destroy
  has_many :postslikes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :commentslikes, dependent: :destroy
  has_many :tagpeople, dependent: :destroy

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
