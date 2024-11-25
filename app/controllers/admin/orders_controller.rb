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