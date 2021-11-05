class NewsletterMailer < ApplicationMailer
  default from: 'facesbyplaces.mailer@gmail.com'
 
  def send_emails(user)
    @user = user
    attachments.inline["logo.png"] = File.read("#{Rails.root}/app/assets/images/logo.png")
    mail(to: @user.email_address, subject: 'FacesByPlaces is now availabe for download!')
  end
  
end
