class ChargesController < ApplicationController

  before_action :set_order, only: [:create]

  #FIXME_AB: remove this
  def create
    @amount = (@order.calculate_total_price * 100).to_i

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => "Deal #{@order.deal.title} by merchant ${@order.deal.merchant.name} bought with quantity #{@order.quantity} at total price of #{@order.calculate_total_price}.",
      :currency    => 'usd'
    )

    set_transaction_details(charge)
    @order.status = "paid"
    #FIXME_AB: before save
    if !@order.save
      re = Stripe::Refund.create(
        charge: charge
      )
    end
    #FIXME_AB: if success, take user to the order's show page with a flash message. Display all the order details with transaction info

  rescue Stripe::CardError => e
    flash[:error] = e.message
    #FIXME_AB: Take user to the edit page
    redirect_to edit_deal_order_path(@order.deal)
  end

  private

  def set_order
    @order = current_user.orders.pending.find_by_id(params[:order_id])
    if @order.nil?
      redirect_to deals_path, alert: "No such Order exists."
    end
  end

  def set_transaction_details(charge)
    @transaction = @order.build_payment_transaction(transaction_params(charge))
    @transaction.user = current_user
    @transaction.save!
  end

  def transaction_params(charge)
    transaction_details = {}
    transaction_details[:charge_id] = charge.id
    transaction_details[:amount] = charge.amount
    transaction_details[:currency] = charge.currency
    transaction_details[:stripe_customer_id] = charge.customer
    transaction_details[:description] = charge.description
    transaction_details[:stripe_email] = params[:stripeEmail]
    transaction_details[:stripe_token] = params[:stripeToken]
    transaction_details[:stripe_token_type] = params[:stripeTokenType]
    transaction_details
  end

end
