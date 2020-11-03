# frozen_string_literal: true

class User < ActiveRecord::Base
<<<<<<< HEAD
=======
<<<<<<< HEAD
  rolify
=======
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
>>>>>>> 26afe749c1b9fd49095153f558a4ed7172ad484b
>>>>>>> 8f127c999b3df3f42d47539db7f9686325e728c4
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  extend Devise::Models
  include DeviseTokenAuth::Concerns::User
  
  has_many :pages
  has_many :posts
  has_many :shares
  
  def self.included(base)
       base.extend ClassMethods
       assert_validations_api!(base)

       base.class_eval do
         validates_presence_of   :email, if: :email_required?, unless: :guest?
         if Devise.activerecord51?
           validates_uniqueness_of :email, allow_blank: true, case_sensitive: true, if: :will_save_change_to_email?
           validates_format_of     :email, with: email_regexp, allow_blank: true, if: :will_save_change_to_email?
         else
           validates_uniqueness_of :email, allow_blank: true, if: :email_changed?
           validates_format_of     :email, with: email_regexp, allow_blank: true, if: :email_changed?
         end

         validates_presence_of     :password, if: :password_required?, unless: :guest?
         validates_confirmation_of :password, if: :password_required?, unless: :guest?
         validates_length_of       :password, within: password_length, allow_blank: true
       end
  end

  def self.new_guest
       new { |u| u.guest = true }
  end
     
  def name
       guest ? "Guest" : username
  end
     
  def move_to(user)
       pages.update_all(user_id: user.id)
       posts.update_all(user_id: user.id)
  end

end
