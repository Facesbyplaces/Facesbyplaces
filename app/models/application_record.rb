class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  # current user for the serializer
  def currentUser
    User.current_user
  end

  # current alm user for the serializer
  def currentAlmUser
    AlmUser.current_alm_user
  end

end
