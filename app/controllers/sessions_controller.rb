class SessionsController < ApplicationController

  before_action :ensure_anonymous, except: [:destroy]

  def new
  end

  def create
    #FIXME_AB: User.verified.....
    user = User.verified.where(email: params[:email]).first
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        user.set_remember_token
        set_remember_me_cookie(user)
      end
      sign_in(user)
      redirect_to root_url
    else
      flash.now[:alert] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    current_user.clear_remember_token!
    reset_session
    cookies.delete :remember_token
    redirect_to root_url, notice: "Logged out"
  end

  private
    #FIXME_AB: set_remember_me_cookie
    def set_remember_me_cookie(user)
      cookies.permanent[:remember_token] = user.remember_token
    end
end
