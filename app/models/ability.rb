# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user = User.first
    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role? :pageadmin
      can :manage, Memorial
    end
  end
end
