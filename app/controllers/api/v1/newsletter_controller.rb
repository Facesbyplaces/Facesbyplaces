class Api::V1::NewsletterController < ApplicationController
    before_action :verify_admin, only: [:app_released]

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

    def app_released
        if Newsletter.first.have_notified
            render json: { success: true, condition: true, status: 200 }, status: 200
        else
            render json: { success: true, condition: false, status: 200 }, status: 200
        end
    end

    private

    def verify_admin
        return render json: {status: "Must be an admin to continue"}, status: 401 unless user().has_role? :admin 
    end
  
  end
  