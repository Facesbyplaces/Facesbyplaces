class Api::V1::PaymentIntentController < ApplicationController
  before_action :check_user
    
    def set_payment_intent
        case params[:page_type]
        when 'Blm'
          @memorial = Blm.find(params[:page_id])
        when 'Memorial'
          @memorial = Memorial.find(params[:page_id])
        end

        @amount = (params[:amount].to_i * 100).to_i
        puts @amount

        token = Stripe::Token.retrieve(params[:token])

        # payment_intent = Stripe::PaymentIntent.create({
        #   payment_method: token.card,
        #   payment_method_types: ['card'],
        #   amount: @amount.to_i,
        #   currency: 'usd',
        #   description: "Donation for #{@memorial.name}",
        #   confirmation_method: 'manual',
        #   confirm: true    
        # }, stripe_account: @memorial.stripe_connect_account_id)

        payment_intent = Stripe::Charge.create({
          currency: 'usd',
          amount: @amount.to_i,
          description: "Donation for #{@memorial.name}",
          source: token,
        }, stripe_account: @memorial.stripe_connect_account_id)
        
        if payment_intent.status == 'succeeded'
          # save to transaction
          Transaction.create(page: @memorial, account: user(), amount: @amount)

          render json: {
            memorial_stripe_account: @memorial.stripe_connect_account_id,
            publishable_key: Rails.configuration.stripe[:publishable_key],
            payment_intent: payment_intent
          }, status: 200
        else 
          render json: {status: "Transaction Failed"}, status: 422
        end
    end
    
end