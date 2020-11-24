class Api::V1::StripeConnectController < ApplicationController

    def success_stripe_connect
        response = Stripe::OAuth.token({
          grant_type: 'authorization_code',
          code: params[:code],
        })
    
        memorial = Memorial.find_by(id: params[:state].split("_")[1])
        memorial.update stripe_connect_account_id: response.stripe_user_id
    end
end