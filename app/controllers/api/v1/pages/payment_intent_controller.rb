class Api::V1::Pages::PaymentIntentController < ApplicationController
    
    def set_payment_intent
        payment_intent = Stripe::PaymentIntent.create({
          payment_method_types: ['card'],
          amount: @amount.to_i,
          currency: 'usd',
          description: "Donation for #{@charity.name}",
        }, stripe_account: @charity.stripe_connect_account_id)
        render json: {
          client_secret: payment_intent[:client_secret]
        }, status: :ok
    end
    
end