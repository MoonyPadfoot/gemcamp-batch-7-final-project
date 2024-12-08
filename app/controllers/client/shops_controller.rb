class Client::ShopsController < ClientsController
  before_action :authenticate_client!, only: :create
  before_action :set_offer, only: :show

  def index
    @offers = Offer.all
    @offers = @offers.filter_by_status(:active)
    @offers = @offers.filter_by_genre(params[:genre]) if params[:genre].present?
    @offers = @offers.page(params[:page]).per(6)

    @banners = Banner.filter_by_status
    @banners = @banners.filter_by_online_at
    @banners = @banners.filter_by_offline_at
    @banners = @banners.order(sort: :asc)

    @news_tickers = NewsTicker.filter_by_status.limit(5)
  end

  def show
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = current_client

    if @order.save
      @order.submit! if @order.may_submit?
      flash[:notice] = 'Offer purchased successfully!'
    else
      flash[:alert] = "Offer purchase failed: #{@order.errors[:base].join(", ")}"
    end
    redirect_to shops_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:offer_id, :amount, :coin)
  end
end