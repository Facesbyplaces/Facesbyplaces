class Api::V1::Payments::PaymentIntentController < ApplicationController
  before_action :check_user
  
  def payment_intent
    intent = Stripe::PaymentIntent.create({
      amount: amount,
      currency: 'usd',
      description: "Donation for #{memorial.name}",
      payment_method_types: ['card'],
      payment_method: payment_method,
      customer: "cus_JitgXxZHgGMSll",
    },{
        stripe_account: stripe_account_id,
    })

    if intent.status == 'requires_confirmation'
      if transaction.save
        render json: {
          payment_intent: intent.id,
          payment_method: intent.payment_method,
          # publishable_key: Rails.configuration.stripe[:publishable_key],
          # transaction: transaction
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

  def platform_account_customer 
    customer = Stripe::Customer.create({
      email: user().email,
    }) 

    Stripe::PaymentMethod.attach(
      params[:payment_method],
      {customer: customer.id},
    )
    return customer.id
  end

  def payment_method
    payment_method = Stripe::PaymentMethod.create({
      customer: platform_account_customer,
      payment_method: params[:payment_method],
    }, {
      stripe_account: stripe_account_id,
    })

    return payment_method.id
    # render json: { payment_method: payment_method }, status: 200
  end

  def confirm_payment_intent
    charge = Stripe::PaymentIntent.confirm(
      params[:client_secret],
      {payment_method: params[:payment_method]}, 
      stripe_account: stripe_account_id)

    render json: { charge: charge, status: charge.status }, status: 200
  end
  
  private

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