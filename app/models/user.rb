# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :async, :confirmable
  include DeviseTokenAuth::Concerns::User
<<<<<<< HEAD

  

=======
  
  has_many :memorials
  has_many :posts
>>>>>>> 47079c7e5cf6082eed6dafc92383945187ef4be2
end
