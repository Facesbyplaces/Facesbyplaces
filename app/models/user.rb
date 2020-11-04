# frozen_string_literal: true

class User < ActiveRecord::Base
  rolify
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  
  has_many :pages
  has_many :posts
  has_many :shares
  has_many :followers

  def self.new_guest
      new { |u| u.guest = true }
  end
     
  def move_to(user)
       pages.update_all(user_id: user.id)
       posts.update_all(user_id: user.id)
  end

end
