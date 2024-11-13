class ShopController < ApplicationController
  before_action :authenticate_client!, only: :create
  before_action :authorize_client, only: :index
  before_action :set_offer, only: :show

  def index
    @offers = Offer.all
                   .filter_by_status
                   .page(params[:page]).per(6)
  end

  def show
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      flash[:notice] = 'Offer purchased successfully!'
    else
      flash[:alert] = 'Offer purchase failed!'
    end
    redirect_to shop_index_path
  end

  private

  def authorize_client
    if current_user&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def current_user
    warden.authenticate(scope: :client)
  end

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:offer_id, :amount, :coin)
  end
end