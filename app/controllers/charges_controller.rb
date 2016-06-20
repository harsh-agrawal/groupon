class ChargesController < ApplicationController
  include ActionView::Helpers::NumberHelper

  #FIXME_AB: check logged in user
  before_action :authenticate
  before_action :set_order, only: [:create]

  def create
    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @order.total_price_in_cents,
      :description => "Deal #{@order.deal.title} by merchant #{@order.deal.merchant.name} bought with quantity #{@order.quantity} at total price of #{@order.calculate_total_price}.",
      :currency    => 'usd'
    )

    if @order.mark_paid(transaction_params(charge))
      redirect_to order_path(@order), alert: "Your order was successfully placed. Amount #{ number_to_currency @order.calculate_total_price} has been deducted from your account."
    else
      Stripe::Refund.create(
        charge: charge
      )
      redirect_to edit_deal_order_path(@order.deal), alert: "Sorry, your order could not be processed and a refund for #{ @order.calculate_total_price } has been initiated."
    end

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to edit_deal_order_path(@order.deal)
  end

  private

  def set_order
    @order = current_user.orders.pending.find_by(id: params[:order_id])
    if @order.nil?
      redirect_to deals_path, alert: "No such Order exists."
    end
  end

  def transaction_params(charge)
    transaction_details = {}
    transaction_details[:charge_id] = charge.id
    transaction_details[:amount] = charge.amount
    transaction_details[:currency] = charge.currency
    transaction_details[:card_brand] = charge.source.brand 
    transaction_details[:exp_month] = charge.source.exp_month
    transaction_details[:exp_year] = charge.source.exp_year
    transaction_details[:last_four_digits] = charge.source.last4
    transaction_details[:stripe_customer_id] = charge.customer
    transaction_details[:description] = charge.description
    transaction_details[:stripe_email] = params[:stripeEmail]
    transaction_details[:stripe_token] = params[:stripeToken]
    transaction_details[:stripe_token_type] = params[:stripeTokenType]
    transaction_details
  end

end
