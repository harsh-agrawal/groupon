class Merchant::CouponsController < Merchant::BaseController

  def new
  end

  def redeem
    coupon = current_merchant.coupons.where("coupons.code = ?", params[:code]).first
    if coupon.present? && coupon.redeemed_at.blank?
      coupon.set_redeemed_at
      flash[:notice] = "Congratulation! Your coupon is valid."
    else
      flash[:alert] = "Sorry. Invalid Coupon"
    end
    redirect_to new_merchant_coupon_path
  end

end
