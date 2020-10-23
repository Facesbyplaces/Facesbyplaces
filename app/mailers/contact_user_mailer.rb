class ContactUserMailer < ApplicationMailer

    def contact_user
        @message = params[:message]
        
        mail(to: params[:email], subject: params[:subject])
    end

end
