class SessionsController < ApplicationController

  before_action :ensure_anonymous, except: [:destroy]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      #FIXME_AB: extract this in a private method "sign_in(user)"
      sign_in(user)
      redirect_to root_url
    else
      redirect_to root_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    reset_session
    redirect_to root_url, notice: "Logged out"
  end

end
