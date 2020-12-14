class Api::V1::PaymentIntentController < ApplicationController
    
    def set_payment_intent
        case params[:page_type]
        when 'Blm'
          @memorial = Blm.find(params[:page_id])
        when 'Memorial'
          @memorial = Memorial.find(params[:page_id])
        end

        @amount = (params[:amount].to_i * 100).to_i
        puts @amount

        # payment_intent = Stripe::PaymentIntent.create({
        #   amount: @amount.to_i,
        #   currency: 'usd',
        #   description: "Donation for #{@memorial.name}",
        # })
        payment_intent = Stripe::PaymentIntent.create({
          payment_method_types: ['card'],
          amount: @amount.to_i,
          currency: 'usd',
          description: "Donation for #{@memorial.name}",
        }, stripe_account: @memorial.stripe_connect_account_id)

        # save to transaction
        Transaction.create(page: @memorial, user: user(), amount: @amount)

        render json: {
          memorial_stripe_account: @memorial.stripe_connect_account_id,
          publishable_key: Rails.configuration.stripe[:publishable_key],
          client_secret: payment_intent[:client_secret],
          id: payment_intent[:id]
        }, status: 200
    end
    
end