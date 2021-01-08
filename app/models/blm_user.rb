# frozen_string_literal: true

class BlmUser < ActiveRecord::Base
  rolify
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
end
