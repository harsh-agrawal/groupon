class PasswordResetsController < ApplicationController

  before_action :ensure_anonymous
  before_action :validate_token

  def create
    #FIXME_AB: Talk to radhika how to handle blank password
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    #FIXME_AB: or you can do: if @user.change_password(p, cp)
    if @user.save
      flash[:alert] = "Password changed successfully."
      @user.verify_forgot_password!
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  private

    def validate_token
      #FIXME_AB: User.verified....
      @user = User.find_by_forgot_password_token(params[:token])
      if @user.nil? || !@user.valid_forgot_password_token?
        flash[:alert] = 'Invalid Token'
        redirect_to new_sessions_path
      end
    end

end
