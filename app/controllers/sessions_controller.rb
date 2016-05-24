class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      #FIXME_AB: extract this in a private method "sign_in(user)"
      session[:user_id] = user.id
      redirect_to root_url
    else
      redirect_to login_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Logged out"
  end
end
