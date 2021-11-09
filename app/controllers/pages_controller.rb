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

  def createNewsletter
    if newsletter_params[:name] === ""
        redirect_to_home("Form cannot be empty.")
    elsif newsletter_params[:email_address] === ""
        redirect_to_home("Form cannot be empty.")
    else   
        @newsletter = Newsletter.new(newsletter_params)
        begin
            @newsletter.save!
        rescue ActiveRecord::RecordInvalid
            redirect_to_home("Email address has already been taken.")
        end
    end
end

  def newHome
  end

  private
    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :password, :password_confirmation)
    end

    def redirect_to_home(message)
        redirect_to root_url, notice: message
    end

    def newsletter_params
        params.require(:newsletter).permit(:name, :email_address, :message)
    end
end
