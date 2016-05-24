class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    #FIXME_AB: Prefer && instead of and
    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_url
    else
      redirect_to login_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    reset_session
    #FIXME_AB: store_url?
    redirect_to store_url, notice: "Logged out"
  end
end
