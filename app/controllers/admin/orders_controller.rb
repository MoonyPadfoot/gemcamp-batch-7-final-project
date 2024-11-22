class Admin::OrdersController < AdminsController
  before_action :set_order, only: [:pay, :cancel]

  def index
    @orders = Order.all
    @orders = @orders.filter_by_serial_number(params[:serial_number]) unless params[:serial_number].blank?
    @orders = @orders.filter_by_email(params[:email]) unless params[:email].blank?
    @orders = @orders.filter_by_offer_name(params[:offer_name]) unless params[:offer_name].blank?
    @orders = @orders.filter_by_created_at(params[:start_date], params[:end_date]) unless params[:start_date].blank? && params[:end_date].blank?
    @orders = @orders.filter_by_genre(params[:genre]) unless params[:genre].blank?
    @orders = @orders.filter_by_state(params[:state]) unless params[:state].blank?
    @orders = @orders.page(params[:page]).per(10)
  end

  def pay
    if @order.may_pay?
      @order.pay!
      flash[:notice] = "Order payed!"
    else
      flash[:alert] = "Cannot pay orders."
    end
    redirect_to orders_path
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Order cancelled!"
      redirect_to orders_path
    else
      flash[:alert] = "Cannot cancel orders."
      render :order, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:order_id])
  end
end