class Merchant::DealsController < Merchant::BaseController

  def index
    @deals = current_merchant.deals.published.paginate(page: params[:page], per_page: 10)
  end

  def show
    @deal = Deal.published.find_by_id(params[:id])
    if @deal.nil?
      redirect_to merchant_deals_path, alert: "No such Deal exists."
    end
  end

end
