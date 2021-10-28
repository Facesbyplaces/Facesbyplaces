class Api::V1::NewsletterController < ApplicationController

    def create
        @newsletter = Newsletter.new(newsletter_params)
        
        if Newsletter.find_by(email_address: newsletter_params[:email_address])
            render json: {
                success: false,
                message: "Oops! Looks like you are already subscribed to the newsletter. We’ll send you an email as soon as the app is available for download. Thank you for your support!",
                status: 400}, status: 400
        else
            @newsletter.save!
            render json: {
                success: true,
                message: "Thank you! You will now receive the latest news from Faces by places. We’ll send you an email as soon as the app is available for download.",
                status: 200}, status: 200
        end
    end

    def notify_subscribed_users
        @users = Newsletter.all

        @users.map{ |user| 

            unless user.have_notified
                # Tell the UserMailer to send a code to verify email after save
                NewsletterMailer.send_emails(user).deliver_now
                user.update(have_notified: true)
            end
        }

         render json: { success: true, message: "Emails sent!", status: 200 }, status: 200
    end

    private
    def newsletter_params
        params.permit(:phone_number, :email_address, :message)
    end

  
  end
  