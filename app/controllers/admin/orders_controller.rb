class Admin::OrdersController < AdminsController
  require 'csv'

  before_action :set_order, only: [:pay, :cancel]

  def index
    @orders = Order.order(created_at: :desc)
    @orders = @orders.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @orders = @orders.filter_by_email(params[:email]) if params[:email].present?
    @orders = @orders.filter_by_offer_name(params[:offer_name]) if params[:offer_name].present?
    @orders = @orders.filter_by_created_at(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    @orders = @orders.filter_by_genre(params[:genre]) if params[:genre].present?
    @orders = @orders.filter_by_state(params[:state]) if params[:state].present?
    @orders = @orders.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            Order.human_attribute_name(:serial_number),
            'Email',
            'Offer',
            Order.human_attribute_name(:amount),
            'Coins',
            Order.human_attribute_name(:genre),
            Order.human_attribute_name(:state),
            Order.human_attribute_name(:created_at),
          ]

          @orders.each do |order|
            csv << [
              order.serial_number, order.user.email, order.offer&.name, order.amount, order.coin, order.genre,
              order.state, order.created_at.strftime("%Y/%m/%d %I:%M %p")
            ]
          end
        end
        render plain: csv_string
      }
    end
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