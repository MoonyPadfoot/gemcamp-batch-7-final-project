class Client::ShopsController < ClientsController
  before_action :authenticate_client!, only: :create
  before_action :set_offer, only: :show

  def index
    @offers = Offer.all
                   .filter_by_status(Offer.statuses[:active])
                   .page(params[:page]).per(6)
  end

  def show
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_user

    if @order.save
      @order.submit! if @order.may_submit?
      flash[:notice] = 'Offer purchased successfully!'
    else
      flash[:alert] = 'Offer purchase failed!'
    end
    redirect_to shop_index_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:offer_id, :amount, :coin)
  end
end