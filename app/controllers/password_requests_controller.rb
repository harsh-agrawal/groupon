class PasswordRequestsController < ApplicationController

  before_action :ensure_anonymous

  def create
    #FIXME_AB: User.verified.where..
    user = User.find_by(email: params[:email])
    #FIXME_AB: user && user.set_forgot_password_token!
    if user
      user.set_forgot_password_token
      UserNotifier.password_reset_mail(user).deliver #FIXME_AB: Move in the model method
      flash[:alert] = "Check your Inbox for Rest Password Link."
      redirect_to root_url
    else
      flash[:alert] = "Invalid User."
      redirect_to new_password_request_path
    end
  end

end
