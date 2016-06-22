class DealsController < ApplicationController

  def index
    @deals = Deal.live.paginate(page: params[:page])
  end

  def past
    @deals = Deal.past.paginate(page: params[:page])
  end

  def search
    @keyword = params[:search]
    @deals = Deal.search(@keyword).paginate(page: params[:page])
  end

  def update_count
    @deal = Deal.published.find_by(id: params[:id])
  end

  def show
    @deal = Deal.published.find_by(id: params[:id])
    if @deal.nil?
      redirect_to deals_path, alert: "No such Deal exists."
    end
  end

end
