class UserNotifier < ApplicationMailer

  default from: CONSTANTS["default_email_from"]

  def verification_mail(user)
    @user = user
    mail to: user.email, subject: 'Welcome to Groupon, please verify your email to continue'
  end

  def password_reset_mail(user)
    @user = user
    mail to: user.email, subject: 'Password Reset Link'
  end

end
