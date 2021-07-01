class Api::V1::Payments::PaymentIntentController < ApplicationController
  before_action :check_user
  
  def payment_intent
    if payment_method != false
      intent = Stripe::PaymentIntent.create({
        amount: amount,
        currency: 'usd',
        description: "Donation for #{memorial.name}",
        payment_method_types: ['card'],
        payment_method: payment_method.id,
        customer: connected_account_customer,
      }, {
          stripe_account: stripe_account_id,
      })
    else
      intent = Stripe::PaymentIntent.create({
        amount: amount,
        currency: 'usd',
        description: "Donation for #{memorial.name}",
      }, {
          stripe_account: stripe_account_id,
      })
    end

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
      render json: { client_secret: intent.client_secret }, status: 200
    end
  end

  #Create or Retrieve the Platform Account Customer
  def platform_account_customer 
    if user().platform_account_customer != nil
      customer = Stripe::Customer.retrieve(user().platform_account_customer)
    else
      customer = Stripe::Customer.create({
        email: user().email,
      })
    end

    #Attach Payment Method
    Stripe::PaymentMethod.attach(
      params[:payment_method],
      {customer: customer.id},
    )

    user().update(platform_account_customer: customer.id)

    return customer.id
  end

  #Create or Retrieve the Connected Account Customer
  def connected_account_customer
    if user().connected_account_customer != nil
      customer = Stripe::Customer.retrieve(user().connected_account_customer)
    else
      customer = Stripe::Customer.create({
        email: user().email,
        payment_method: payment_method.id,
      }, {
        stripe_account: stripe_account_id,
      })
    end

    user().update(connected_account_customer: customer.id)

    return customer.id
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
        number: '4242424242424242',
        exp_month: 6,
        exp_year: 2022,
        cvc: '314',
      },
    })

    render json: { method: method }, status: 200
  end
  
  private

  def stripe_account_id
    return User.find_by(email: "admin@email.com").device_token
  end

  def payment_method
    if params[:payment_method].present?
      payment_method = Stripe::PaymentMethod.create({
        customer: platform_account_customer,
        payment_method: params[:payment_method],
      }, {
        stripe_account: stripe_account_id,
      })

      return payment_method
    else
      return false
    end
    # render json: { payment_method: payment_method }, status: 200
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