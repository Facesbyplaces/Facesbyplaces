class VerificationMailer < ApplicationMailer
    default from: 'facesbyplaces.mailer@gmail.com'
 
  def verify_email(user)
    @user = user
    mail(to: @user.email, subject: 'Verification Code')
  end
  
end
