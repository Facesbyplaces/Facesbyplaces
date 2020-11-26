class SendStripeLinkMailer < ApplicationMailer
    default from: 'facesbyplaces.mailer@gmail.com'
 
  def send_memorial_link(redirect_uri, client_id, user, memorial)
    @redirect_uri = redirect_uri
    @client_id = client_id
    @user = user
    @memorial = memorial

    mail(to: @user.email, subject: 'Register Stripe Account')
  end

  def send_blm_link(redirect_uri, client_id, user, blm)
    @redirect_uri = redirect_uri
    @client_id = client_id
    @user = user
    @blm = blm

    mail(to: @user.email, subject: 'Register Stripe Account')
  end

end
