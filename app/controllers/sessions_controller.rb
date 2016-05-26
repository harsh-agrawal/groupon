class SessionsController < ApplicationController

  before_action :ensure_anonymous, except: [:destroy]

  def new
  end

  def create
    #FIXME_AB: User.verified.....
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      #FIXME_AB: extract this in a private method "sign_in(user)"
      if params[:remember_me]
        user.set_remember_token
        set_cookies(user)
      end
      sign_in(user)
      redirect_to root_url
    else
      redirect_to root_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    current_user.reset_remember_token!
    reset_session
    cookies.delete :remember_token
    redirect_to root_url, notice: "Logged out"
  end

  private
    #FIXME_AB: set_remember_me_cookie
    def set_cookies(user)
      cookies.permanent[:remember_token] = user.remember_token
    end
end
