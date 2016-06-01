class Admin::DealsController < Admin::BaseController

  before_action :set_deal, only: [:show, :edit, :destroy, :update, :publish, :unpublish]

  def new
    @deal = Deal.new
    @deal.locations.build
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      flash[:alert] = "Deal successfully created."
      redirect_to admin_url
    else
      render 'new'
    end
  end

  def update
    if @deal.update(deal_params)
      redirect_to admin_deal_path(@deal), notice: 'Deal was successfully updated.'
    else
      render :edit
    end

  end

  def index
    @deals = Deal.all
  end

  def publish
    @published = @deal.publish
    @errors_full_messages =  @deal.errors.full_messages + @deal.locations.first.errors.full_messages 
  end

  def unpublish
    @unpublished = @deal.unpublish
  end

  def destroy
    @deal.destroy
    redirect_to admin_deals_path, notice: 'Deal was successfully updated.'
  end

  private

  def deal_params
    params.require(:deal).permit(:title, :description, :min_qty, :max_qty, :start_time, :expire_time, :price, :max_qty_per_customer, :instructions, :category_id, :merchant_id, locations_attributes: [:id, :address, :city, :state, :country])
  end

  def set_deal
    @deal = Deal.find(params[:id])
  end

end
