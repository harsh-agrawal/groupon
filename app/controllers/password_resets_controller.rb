class PasswordResetsController < ApplicationController

  before_action :ensure_anonymous
  before_action :validate_token

  def create
    #FIXME_AB: Talk to radhika how to handle blank password
    #FIXME_AB: or you can do: if @user.change_password(p, cp)
    if @user.change_password( params[:password], params[:password_confirmation])
      flash[:alert] = "Password changed successfully."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  private

    def validate_token
      #FIXME_AB: User.verified....
      @user = User.verified.where(forgot_password_token: params[:token]).first
      if @user.nil? || !@user.valid_forgot_password_token?
        flash[:alert] = 'Invalid Token'
        redirect_to new_sessions_path
      end
    end

end
