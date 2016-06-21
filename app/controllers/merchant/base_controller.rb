class Merchant::BaseController < ApplicationController

  before_action :ensure_merchant
  helper_method :current_merchant
  layout "merchant"

  private

  def ensure_merchant
    if !current_merchant
      flash[:notice] = "Your are not allowed to access this page."
      redirect_to root_url
    end
  end

  def current_merchant
    if session[:merchant_id]
      @current_merchant ||=  Merchant.find(session[:merchant_id])
    end
  end

end
