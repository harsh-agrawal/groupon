class OrdersController < ApplicationController

  before_action :authenticate
  before_action :set_deal, only: [:new, :edit, :destroy]
  before_action :set_order, only: [:edit, :destroy]

  def new
    @order = @deal.orders.new
    @order.user = current_user
    if @order.save
      redirect_to edit_deal_order_path(@deal, @order)
    else
      render "deals/show"
    end
  end

  def edit
    if params[:quantity]
      @order.quantity = params[:quantity]
    end 
    if !@order.save
      render :edit
    end
  end

  def destroy
    if @order.destroy
      redirect_to deal_path(@deal), notice: 'Order was cancelled.'
    else
      redirect_to :back, alert: 'Fail to cancel the order.'
    end
  end

  private

  def set_deal
    #FIXME_AB: no check for deal status
    @deal = Deal.live.find_by_id(params[:deal_id])
    if @deal.nil?
      redirect_to deals_index_path, alert: "No such Deal exists."
    end
  end

  #FIXME_AB: set_pending_order
  def set_order
    #FIXME_AB: current_user.orders.pending.find_by
    @order = current_user.orders.pending.find_by_id(params[:id])
    if @order.nil?
      redirect_to deals_index_path, alert: "No such Order exists."
    end
  end

end
