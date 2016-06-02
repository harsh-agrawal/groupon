class Admin::DealsController < Admin::BaseController

  before_action :set_deal, only: [:show, :edit, :destroy, :update, :publish, :unpublish]

  def new
    #FIXME_AB: mark * for requried fields
    @deal = Deal.new
    @deal.locations.build
  end

  def create
    @deal = Deal.new(deal_params)
    if @deal.save
      #FIXME_AB: merge following two lines
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
    @errors_full_messages =  @deal.errors.full_messages + @deal.locations.first.errors.full_messages
  end

  def unpublish
    @unpublished = @deal.unpublish
  end

  def destroy
    #FIXME_AB: you can't be sure that the object is destroyed, if else needed
    if @deal.destroy
      redirect_to admin_deals_path, notice: 'Deal was successfully deleted.'
    else
      redirect_to admin_url, alert: 'Fail to delete the Deal.'
    end
  end

  private

  def deal_params
    params.require(:deal).permit(:title, :description, :min_qty, :max_qty, :start_time, :expire_time, :price, :max_qty_per_customer, :instructions, :category_id, :merchant_id,
                                 locations_attributes: [:id, :address, :city, :state, :country]
                                 )
  end

  def set_deal
    if (@deal = Deal.find_by_id(params[:id]))
      @deal
    else
      redirect_to admin_url, alert: "No such Deal exists."
    end
    #FIXME_AB: what if deal not found
  end

end
