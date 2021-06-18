class Api::V1::Payments::PaymentIntentController < ApplicationController
  before_action :check_user

  # def create_transaction
  #   if payment_intent.status == 'requires_confirmation'
  #     if transaction.save
  #       render json: {
  #         publishable_key: Rails.configuration.stripe[:publishable_key],
  #         payment_intent: payment_intent.client_secret,
  #         transaction: transaction
  #       }, status: 200
  #     else
  #       render json: {
  #         error: transaction.errors.full_messages,
  #       }, status: 404
  #     end
  #   elsif payment_intent.status == 'requires_payment_method'
  #     render json: { intent: payment_intent, status: "Requires Payment Method" }, status: 422
  #   end
  # end

  def payment_intent
    intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      description: "Donation for #{memorial.name}",
      payment_method: params[:payment_method],
    }, stripe_account: stripe_account_id)

    return render json: { intent: intent }, status: 200
  end

  def create_payment_method
    method = Stripe::PaymentMethod.create({
      type: 'card',
      card: {
        number: '4242424242424242',
        exp_month: 6,
        exp_year: 2022,
        cvc: '314',
      },
    })

    render json: { method: method }, status: 200
  end

  private

  def payment_method
    return params[:payment_method]
  end
  
  def stripe_account_id
    return User.find_by(email: "admin@email.com").device_token
  end

  def amount
    return (params[:amount].to_i * 100).to_i
  end

  def memorial
    case params[:page_type]
    when 'Blm'
      return Blm.find(params[:page_id])
    when 'Memorial'
      return Memorial.find(params[:page_id])
    end
  end

  def transaction
    return Transaction.create(page: memorial, account: user(), amount: amount)
  end

end