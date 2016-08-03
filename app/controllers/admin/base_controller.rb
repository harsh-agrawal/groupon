class Admin::BaseController < ApplicationController

  before_action :ensure_admin
  layout "admin"

  private

  def ensure_admin
    if signed_in? && !current_user.admin?
      redirect_to root_url, notice: "You do not have rights to access this page."
    end
  end

end
