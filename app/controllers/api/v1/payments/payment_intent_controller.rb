class Api::V1::Payments::PaymentIntentController < ApplicationController
  before_action :check_user

  def set_payment_intent
    require 'stripe'
    Stripe.api_key = Rails.configuration.stripe[:secret_key]

    intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      description: "Donation for #{memorial.name}",
      payment_method: params[:payment_method]
    }, stripe_account: stripe_account_id)

    if intent.status == 'requires_confirmation'
      if transaction.save
        render json: {
          publishable_key: Rails.configuration.stripe[:publishable_key],
          payment_intent: intent,
          transaction: transaction
        }, status: 200
      else
        render json: {
          error: transaction.errors.full_messages,
        }, status: 404
      end
    elsif intent.status == 'requires_payment_method'
      render json: { intent: intent, status: "Requires Payment Method" }, status: 422
    end
  end

  private
  def report_params
    params.require(:card).permit(:number, :exp_month, :exp_year, :cvc)
  end

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