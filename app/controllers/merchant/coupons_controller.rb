class Merchant::CouponsController < Merchant::BaseController

  before_action :check_coupon_code, only: [:redeem]

  def new
  end

  def redeem
    if @coupon.redeem
      redirect_to merchant_deal_path(@coupon.order.deal), notice: "Congratulation! Your coupon is valid and redeemed."
    else
    redirect_to new_merchant_coupon_path, alert: "Sorry. Could not redeem the coupon.\n#{@coupon.errors.full_messages.join(', ')}"
    end
  end

  private

  def check_coupon_code
    @coupon = current_merchant.coupons.where("coupons.code = ?", params[:code]).first
    if @coupon.nil?
      redirect_to new_merchant_coupon_path, alert: "Invalid Coupon."
    end
  end

end
