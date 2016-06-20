class Merchant::BaseController < ApplicationController

  before_action :ensure_merchant
  layout "merchant"

  private

  def ensure_merchant
    if !current_merchant
      flash[:notice] = "Your are not allowed to access this page."
      redirect_to root_url
    end
  end

end
