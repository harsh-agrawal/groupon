class MerchantSessionsController < ApplicationController

  before_action :ensure_merchant, except: [:destroy]

  def new
  end

  def create
    merchant = Merchant.where(email: params[:email]).first
    if merchant && merchant.authenticate(params[:password])
      session[:merchant_id] = merchant.id
      redirect_to new_merchant_coupon_path
    else
      flash.now[:alert] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Logged out"
  end

  private

  def ensure_merchant
    if current_merchant
      flash[:notice] = "Your are not allowed to access this page."
      redirect_to root_url
    end
  end

end
