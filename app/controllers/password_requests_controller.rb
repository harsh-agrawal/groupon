class PasswordRequestsController < ApplicationController

  before_action :ensure_anonymous

  def create
    user = User.verified.find_by(email: params[:email])
    if user && user.set_forgot_password_token!
      flash[:alert] = "Check your Inbox for Reset Password Link."
      redirect_to root_url
    else
      flash[:alert] = "Email not registered with us."
      redirect_to new_password_request_path
    end
  end

end
