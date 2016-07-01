class Admin::ReportsController < Admin::BaseController

  def merchants
    @start_time, @end_time = get_data_from_params
    if get_data_from_params
      @merchants = Merchant.includes(:orders).where("orders.processed_at BETWEEN ?  AND ?", @start_time, @end_time).references(:orders)
    else
      @merchants = Merchant.includes(:deals)
    end
    @merchants = @merchants.sort{ |x, y| y.order_sum(@start_time, @end_time) <=> x.order_sum(@start_time, @end_time) }
  end

  private

  def get_data_from_params
    if params[:start_time] && params[:end_time]
      from = Time.new params[:start_time][:year].to_i, params[:start_time][:month].to_i, params[:start_time][:day].to_i, params[:start_time][:hour].to_i, params[:start_time][:minute].to_i
      to = Time.new params[:end_time][:year].to_i, params[:end_time][:month].to_i, params[:end_time][:day].to_i, params[:end_time][:hour].to_i, params[:end_time][:minute].to_i
      return from, to
    end
  end

end
