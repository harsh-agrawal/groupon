class UserNotifier < ApplicationMailer

  #FIXME_AB:  use constants
  default from: 'Harsh Agrawal <harsh@vinsol.com>'

  #FIXME_AB: rename this function 
  def registration_confirmation(user)
    @user = user
    mail to: user.email, subject: 'Registration Confirmation'
  end

end
