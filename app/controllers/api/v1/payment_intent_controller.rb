class Api::V1::PaymentIntentController < ApplicationController
    
    def set_payment_intent
        if params[:memorial_id].present?
          @memorial = Memorial.find(params[:memorial_id])
        elsif params[:blm_id].present?
          @memorial = Blm.find(params[:blm_id])
        end

        @amount = (params[:amount].to_i * 100).to_i
        puts @amount
        payment_intent = Stripe::PaymentIntent.create({
          payment_method_types: ['card'],
          amount: @amount.to_i,
          currency: 'usd',
          description: "Donation for #{@memorial.name}",
        }, stripe_account: @memorial.stripe_connect_account_id)
        render json: {
          client_secret: payment_intent[:client_secret]
        }, status: :ok
    end
    
end