class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # current user for the serializer
  def current_user
      User.first
  end
end
