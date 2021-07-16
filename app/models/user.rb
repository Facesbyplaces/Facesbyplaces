# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify #:role_cname => 'BlmRole'

  has_many :authorizations
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  extend Devise::Models
  include DeviseTokenAuth::Concerns::User

  has_many :pageowners, as: :account, dependent: :destroy
  has_many :followers, as: :account, dependent: :destroy
  has_many :posts, as: :account, dependent: :destroy
  has_many :relationships, as: :account, dependent: :destroy
  has_many :replies, as: :account, dependent: :destroy
  has_many :postslikes, as: :account, dependent: :destroy
  has_many :comments, as: :account, dependent: :destroy
  has_many :commentslikes, as: :account, dependent: :destroy
  has_one :notifsetting, as: :account, dependent: :destroy
  has_many :tagpeople, as: :account, dependent: :destroy
  has_many :transactions, as: :account, dependent: :destroy
  has_many :notifications, as: :recipient, dependent: :destroy
  has_many :notification_actors, class_name: 'Notification', as: :actor, dependent: :destroy

  has_one_attached :image, dependent: :destroy
  
  # Search user
  include PgSearch::Model
  multisearchable against: [:first_name, :last_name, :phone_number, :email, :username, :birthdate, :birthplace]

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

  def blm_users
    self.users
  end

  def self.current
    Thread.current[:user]
  end
  
  # def self.current=(user)
  #   Thread.current[:user] = user
  # end

end
