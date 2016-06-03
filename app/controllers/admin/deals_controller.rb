class Admin::DealsController < Admin::BaseController

  before_action :set_deal, only: [:show, :edit, :destroy, :update, :publish, :unpublish]

  def new
    @deal = Deal.new
    @deal.locations.build
    @deal.deal_images.build
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      redirect_to admin_url, alert: "Deal successfully created."
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
    @errors_full_messages =  @deal.errors.full_messages
  end

  def unpublish
    @unpublished = @deal.unpublish
  end

  def destroy
    if @deal.destroy
      redirect_to admin_deals_path, notice: 'Deal was successfully deleted.'
    else
      redirect_to admin_url, alert: 'Fail to delete the Deal.'
    end
  end

  private

  def deal_params
    params.require(:deal).permit(:title, :description, :min_qty, :max_qty, :start_time, :expire_time, :price, :max_qty_per_customer, :instructions, :category_id, :merchant_id,
                                 locations_attributes: [:id, :address, :city, :state, :country, :_destroy],
                                 deal_images_attributes: [:id, :image, :_destroy]
                                 )
  end

  def set_deal
    @deal = Deal.find_by_id(params[:id])
    if @deal.nil?
      redirect_to admin_url, alert: "No such Deal exists."
    end
  end

end
