# frozen_string_literal: true

class BlmUser < ActiveRecord::Base
  rolify

  has_many :authorizations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  has_many :pageowners, as: :account, dependent: :destroy
  has_many :followers, as: :account, dependent: :destroy
  has_many :posts, as: :account, dependent: :destroy
  has_many :relationships, as: :account, dependent: :destroy
  has_many :replies, as: :account, dependent: :destroy
  has_many :postslikes, as: :account, dependent: :destroy
  has_many :comments, as: :account, dependent: :destroy
  has_many :commentslikes, as: :account, dependent: :destroy
  has_many :notifsetting, as: :account, dependent: :destroy
  has_many :tagpeople, as: :account, dependent: :destroy
  has_many :transactions, as: :account, dependent: :destroy

  has_one_attached :image, dependent: :destroy

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
