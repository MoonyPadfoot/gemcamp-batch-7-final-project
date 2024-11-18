class OrderController < ApplicationController
  before_action :authenticate_admin!, only: :index
  before_action :authorize_admin, only: :index
  before_action :authenticate_client!, only: :cancel
  before_action :authorize_client, only: :cancel
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
      @order.pay
      flash[:notice] = "Order payed!"
    else
      flash[:alert] = "Cannot pay order."
    end
    redirect_to me_order_history_path
  end

  def cancel
    if @order.may_cancel?
      @order.cancel!
      flash[:notice] = "Order cancelled!"
      redirect_to me_order_history_path
    else
      flash[:alert] = "Cannot cancel order."
      render :winning_history, status: :unprocessable_entity
    end
  end

  private

  private

  def authorize_client
    if current_client&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def authorize_admin
    if current_admin&.client?
      sign_out(current_client)
      redirect_to new_admin_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def set_order
    @order = Order.find(params[:order_id])
  end
end