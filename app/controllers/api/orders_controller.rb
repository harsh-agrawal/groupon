class Api::OrdersController < ApplicationController

  before_action :valid_token, only: [:show]

  def show
    @orders = @user.orders.placed.includes(:payment_transactions)
  end

  def valid_token
    @user = User.verified.find_by(authentication_token: params[:token])
    if @user.nil?
      render :json => { :error => "Invalid user." }
    end
  end

end
