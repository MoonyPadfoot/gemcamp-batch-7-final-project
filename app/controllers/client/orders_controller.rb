class Client::OrdersController < ClientsController
  before_action :set_order, only: :cancel

  def index
    @orders = Order.all
    @orders = @orders.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.filter_by_email(params[:email]) if params[:email].present?
    @orders = @orders.filter_by_offer_name(params[:offer_name]) if params[:offer_name].present?
    @orders = @orders.filter_by_created_at(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    @orders = @orders.filter_by_genre(params[:genre]) if params[:genre].present?
    @orders = @orders.filter_by_state(params[:state]) if params[:state].present?
    @orders = @orders.page(params[:page]).per(10)
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Order cancelled!"
      redirect_to me_order_history_path
    else
      flash[:alert] = "Cannot cancel orders."
      render :winning_history, status: :unprocessable_entity
    end
  end

  def set_order
    @order = Order.find(params[:order_id])
  end
end