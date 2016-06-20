class MerchantsController < ApplicationController

  before_action :set_merchant, only: [:deals]

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params)
    if @merchant.save
      flash[:alert] = "Please login. Merchant #{@merchant.name} was successfully created."
      redirect_to root_url
    else
      render action: 'new'
    end
  end

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

  def merchant_params
    params.require(:merchant).permit(:name, :password, :password_confirmation, :email)
  end

end
