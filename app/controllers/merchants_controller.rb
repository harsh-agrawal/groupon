class MerchantsController < ApplicationController

  before_action :set_merchant, only: [:deals]

  def deals
    @deals = @merchant.deals.published.includes(:deal_images).paginate(page: params[:page])
  end

  private

  def set_merchant
    @merchant = Merchant.find_by(id: params[:id])
    if @merchant.nil?
      redirect_to deals_path, alert: "No such Merchant exists."
    end
  end

end
