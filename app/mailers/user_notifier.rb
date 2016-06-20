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

  def refund_mail(order)
    @order = order
    mail to: @order.user.email, subject: "Refund amount for #{ @order.id }"
  end

  def coupon_mail(order)
    @order = order
    #FIXME_AB: change subject to order/deal specific
    mail to: @order.user.email, subject: "Coupons For Your Order #{ @order.id }"
  end

end
