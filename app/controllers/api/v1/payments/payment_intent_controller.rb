class Api::V1::Payments::PaymentIntentController < ApplicationController
  set_account_type = 1 ? (before_action :authenticate_user!) : (before_action :authenticate_alm_user!) 
  
  def payment_intent
    if payment_method != false
      intent = Stripe::PaymentIntent.create({
        amount: amount,
        currency: 'usd',
        description: "Donation for #{memorial.name}",
        payment_method_types: ['card'],
        payment_method: payment_method,
        customer: connected_account_customer,
      }, {
          stripe_account: stripe_account_id,
      })
    else
      intent = Stripe::PaymentIntent.create({
        amount: amount,
        currency: 'usd',
        description: "Donation for #{memorial.name}",
      })
    end

    # Save to Transaction
    if intent.status == 'requires_confirmation'
      if transaction.save
        render json: {
          payment_intent: intent.id,
          payment_method: intent.payment_method,
          # client_secret:  intent.client_secret,
        }, status: 200
      else
        render json: {
          error: transaction.errors.full_messages,
        }, status: 404
      end
    elsif intent.status == 'requires_payment_method'
      render json: { client_secret: intent.client_secret, token: token }, status: 200
    end
  end

  # PAYMENT TEST ACTIONS
  def confirm_payment_intent
    charge = Stripe::PaymentIntent.confirm(
      params[:client_secret],
      {payment_method: params[:payment_method]}, 
      stripe_account: stripe_account_id)

    render json: { charge: charge, status: charge.status }, status: 200
  end

  def create_payment_method
    method = Stripe::PaymentMethod.create({
      type: 'card',
      card: {
        number: '5555555555554444',
        exp_month: 6,
        exp_year: 2022,
        cvc: '314',
      },
    })

    render json: { method: method }, status: 200
  end
  
  private

  def stripe_account_id
    return Rails.application.credentials.dig(:stripe, Rails.env.to_sym, :connected_account_id)
  end

  # Clone payment method to connected account id
  def payment_method
    if params[:payment_method].present?
      payment_method = Stripe::PaymentMethod.create({
        customer: platform_account_customer,
        payment_method: params[:payment_method],
      }, {
        stripe_account: stripe_account_id,
      })

      return payment_method.id
    else
      return false
    end
  end

  # Create or Retrieve the Connected Account Customer
  def connected_account_customer
    customer = Stripe::Customer.create({
      email: user().email,
      payment_method: payment_method,
    }, {
      stripe_account: stripe_account_id,
    })

    user().update(connected_account_customer: customer.id)

    return customer.id
  end

  # Create or Retrieve the Platform Account Customer
  def platform_account_customer 
    if user().platform_account_customer != nil
      customer = Stripe::Customer.retrieve(user().platform_account_customer)
    else
      customer = Stripe::Customer.create({
        email: user().email,
      })
    end

    # Attach Payment Method
    Stripe::PaymentMethod.attach(
      params[:payment_method],
      {customer: customer.id},
    )

    user().update(platform_account_customer: customer.id)

    return customer.id
  end

  def token
    token = Stripe::Token.create({
      card: {
        number: '4242424242424242',
        exp_month: 7,
        exp_year: 2022,
        cvc: '314',
      },
    })

    return token.id
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