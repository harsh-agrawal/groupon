class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception

  helper_method :signed_in?, :sign_in, :authenticate, :current_user, :current_merchant

  before_action :login_from_cookie, unless: :signed_in?

  def ensure_anonymous
    if signed_in?
      flash[:notice] = "Your are not allowed to access this page."
      redirect_to root_url
    end
  end

  protected

  def current_merchant
    if session[:merchant_id]
      @current_merchant ||=  Merchant.find(session[:merchant_id])
    end
  end

  def authenticate
    if !signed_in?
      redirect_to :back, alert: 'Please Login and Come Back to buy this Deal.'
    end
  end

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
    if cookies[:remember_token].present? && (user = User.verified.find_by_remember_token(cookies[:remember_token]))
      sign_in(user)
    end
  end

end
