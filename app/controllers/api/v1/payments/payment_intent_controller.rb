class Api::V1::Payments::PaymentIntentController < ApplicationController
  # before_action :check_user

  def set_payment_intent
    intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      description: "Donation for #{memorial.name}",
      customer: stripe_account_id
    })

    if intent.status == 'succeeded'
      if transaction.save
        render json: {
          memorial_stripe_account: memorial.stripe_connect_account_id,
          publishable_key: Rails.configuration.stripe[:publishable_key],
          payment_intent: intent,
          transaction: transaction
        }, status: 200
      else
        render json: {
          error: transaction.errors.full_messages,
        }, status: 404
      end
    else 
      render json: {status: "Transaction Failed"}, status: 422
    end
  end

  private
  def report_params
    params.require(:card).permit(:number, :exp_month, :exp_year, :cvc)
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