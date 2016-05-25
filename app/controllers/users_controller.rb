class UsersController < ApplicationController

#FIXME_AB: logged in user should not be able to access signup form / create / activate

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:alert] = "Please confirm your email address to continue. User #{@user.name} was successfully created."
      redirect_to root_url
    else
      render action: 'new'
    end
  end

  def account_activation
    user = User.find_by_verification_token(params[:token])

    #FIXME_AB: 
    # if user && user.valid_verification_token? && user.verify!
    #   successfully
    # else
    #   error
    # end

    if user
      if user.verify!
        user.update_after_verification
        session[:user_id] = user.id
        flash[:alert] = "Welcome to the Groupon! Your email has been confirmed."
        redirect_to root_url
      else
        flash[:alert] = "Activation Link Expired. Please send another link by entering your
          EmailId"
        redirect_to root_url
      end
    else
      flash[:alert] = "Sorry. User does not exist"
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation, :email)
  end

end
