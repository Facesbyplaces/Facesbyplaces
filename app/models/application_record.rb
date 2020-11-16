class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # current user for the serializer
  def currentUser
      User.current
  end
end
