class Merchant::DealsController < Merchant::BaseController

  def index
    @deals = current_merchant.deals.includes(:deal_images).published.paginate(page: params[:page], per_page: 10)
  end

  def show
    @deal = current_merchant.deals.published.find_by(id: params[:id])
    if @deal.nil?
      redirect_to merchant_deals_path, alert: "No such Deal exists."
    end
  end

end
