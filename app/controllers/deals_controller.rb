class DealsController < ApplicationController

  def index
    @deals = Deal.live.paginate(:page => params[:page])
  end

  def past
    @deals = Deal.past.paginate(:page => params[:page])
  end

  def search
    @keyword = params[:search]
    @deals = Deal.search(@keyword).paginate(:page => params[:page])
  end

  def show
    @deal = Deal.find_by_id(params[:id])
    if @deal.nil?
      redirect_to deals_index_path, alert: "No such Deal exists."
    end
  end

end
