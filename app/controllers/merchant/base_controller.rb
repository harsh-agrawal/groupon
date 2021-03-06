class Merchant::BaseController < ApplicationController

  before_action :ensure_merchant
  helper_method :current_merchant
  layout "merchant"

  private

  def ensure_merchant
    if !current_merchant
      flash[:notice] = "You need to be logged as merchant to access this page"
      #FIXME_AB: take him to merchant login page
      redirect_to new_merchant_sessions_path
    end
  end

  def current_merchant
    if session[:merchant_id]
      @current_merchant ||=  Merchant.find(session[:merchant_id])
    end
  end

end
