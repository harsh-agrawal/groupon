class CategoriesController < ApplicationController

def deals
  @category = Category.find_by_id(params[:id])
  if @category.nil?
    redirect_to deals_path, alert: "No such Category exists."
  else
    @deals = @category.deals.published.paginate(:page => params[:page], :per_page => 10)
  end
end

end
