class PagesController < ApplicationController

  def home
  end

  def about
  end

  def terms
  end

  def privacy
  end
  
  def signUp
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      #user mailer send?
      redirect_to sign_up_path
    else
      render :signUp
    end
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
    end
end
