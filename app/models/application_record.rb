class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # current user for the serializer
  def user
      User.first
  end
end
