class UserMailer < ApplicationMailer
    default from: 'notifications@example.com'
 
  def welcome_email
    @user = params[:user]
    @url  = 'smtp://127.0.0.1:1025'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end
