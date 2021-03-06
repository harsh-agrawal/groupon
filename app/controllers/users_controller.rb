class UsersController < ApplicationController

  before_action :ensure_anonymous

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:alert] = "Please confirm your email address to continue. User #{@user.first_name} was successfully created."
      redirect_to root_url
    else
      render action: 'new'
    end
  end

  def account_activation
    user = User.find_by_verification_token(params[:token])
    if user && user.valid_verification_token? && user.verify!
      sign_in(user)
      flash[:notice] = "Welcome to the Groupon! Your email has been confirmed."
    else
      flash[:notice] = "Invalid URL."
    end
    redirect_to root_url
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :password, :password_confirmation, :email)
  end

end
