class NewsletterMailer < ApplicationMailer
  default from: 'facesbyplaces.mailer@gmail.com'
 
  def send_emails(user)
    @user = user
    mail(to: @user.email_address, subject: 'FacesByPlaces is now availabe for download!')
  end
  
end
