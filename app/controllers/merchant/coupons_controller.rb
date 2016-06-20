class Merchant::CouponsController < Merchant::BaseController

  def new

  end

  def redeem
    @coupons = current_merchant.coupons
    if @coupons.any?
      @coupons.each do |coupon|
        if (coupon.code == params[:code] && redeemed_at.blank?)
          coupon.redeemed_at = Time.current
          coupon.save
          flash[:alert] = "Congratulation! Your coupon is valid."
        else
          flash[:alert] = "Sorry. Invalid Coupon"
        end
      end
    else
      flash[:alert] = "No coupons for you."
    end
    redirect_to new_merchant_coupon_path
  end

end
