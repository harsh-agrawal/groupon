class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Please confirm your email address to continue'
      redirect_to root_url,  notice: "User #{@user.name} was successfully created."
    else
      format.html { render action: 'new' }
    end
  end

  def account_activation
  end
  # def account_activation
  #   user = User.find_by_verification_token(params[:id])
  #   if user
  #     user.email_activate
  #     flash[:success] = "Welcome to the Groupon! Your email has been confirmed.
  #     Please sign in to continue."
  #     redirect_to signin_url
  #   else
  #     flash[:error] = "Sorry. User does not exist"
  #     redirect_to root_url
  #   end
  # end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email)
  end

end
