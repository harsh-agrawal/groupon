class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :signed_in?, :sign_in

  #FIXME_AB: login_from_cookie
  before_action :login_from_cookie

  def ensure_anonymous
    if signed_in?
      flash[:notice] = "Your are not allowed to access this page."
      redirect_to root_url
    end
  end

  protected

    def current_user
      if session[:user_id]
        @current_user ||=  User.verified.find(session[:user_id])
      else
        nil
      end
    end

    def signed_in?
      !!current_user
    end

    def sign_in(user)
      session[:user_id] = user.id
      logger.debug "User Logged In"
    end

    def login_from_cookie
      if !signed_in? && cookies[:remember_token].present?
        #FIXME_AB: User.verified.where(remember_token: cookies[:remember_token])
        #FIXME_AB: sign in only when user found else nothing
        user = User.verified.find_by_remember_token(cookies[:remember_token])
        if user
          sign_in(user)
        end
      end
    end

end

#FIXME_AB: make a method authenticate which will redirect user to login page if user is not logged in
#FIXME_AB: make another method ensure_anonymous which will redirect user to root page if user is logged in

#FIXME_AB: login and signup should only come when user is not logged in
#FIXME_AB: logout should come only when user is logged in
#FIXME_AB: Basically add authorization
#FIXME_AB: create user button should say signup
