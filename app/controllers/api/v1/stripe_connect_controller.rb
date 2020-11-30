class Api::V1::StripeConnectController < ApplicationController

    def success_stripe_connect
        response = Stripe::OAuth.token({
          grant_type: 'authorization_code',
          code: params[:code],
        })
        
        if params[:state].split("_")[0] == "blm"
          memorial = Blm.find_by(id: params[:state].split("_")[1])
          memorial.update stripe_connect_account_id: response.stripe_user_id
          render json: {success: true, message: "Stripe Successfully Connected!", status: 200}, status: 200
        elsif params[:state].split("_")[0] == "memorial"
          memorial = Memorial.find_by(id: params[:state].split("_")[1])
          memorial.update stripe_connect_account_id: response.stripe_user_id
          render json: {success: true, message: "Stripe Successfully Connected!", status: 200}, status: 200
        end
    end

end