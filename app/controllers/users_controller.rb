class UsersController < ApplicationController
  #FIXME_AB: remove unwanted methods

  def index
  end

  def new
    @user = User.new
  end

  def create
    #FIXME_AB: For now we are just handling HTML requests so remove respond_to 
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        #FIXME_AB: after commit
        #FIXME_AB: UserNotifier.verification_mail
        UserNotifier.registration_confirmation(@user).deliver
        flash[:success] = "Please confirm your email address to continue"
        #FIXME_AB: we don't need index action for now, so remore index action and redirec to home page
        format.html { redirect_to users_url,
          notice: "User #{@user.name} was successfully created." }
        format.json { render action: 'show',
          status: :created, location: @user }
      else
        format.html { render action: 'new' }
        format.json { render json: @user.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_url,
          notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors,
          status: :unprocessable_entity }
      end
    end
  end

  def destroy
   begin
     @user.destroy
     flash[:notice] = "User #{@user.name} deleted"
     if @user.errors.present?
       flash[:notice] = @user.errors.full_messages.join(',')
     end
     rescue StandardError => e
       flash[:notice] = e.message
     end
     
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
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
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :email)
    end

end
