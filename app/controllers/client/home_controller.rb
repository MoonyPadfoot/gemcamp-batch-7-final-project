class Client::HomeController < ClientsController
  before_action :authenticate_client!, except: :index
  def index
    @banners = Banner.filter_by_status
    @banners = @banners.filter_by_online_at
    @banners = @banners.filter_by_offline_at
    @banners = @banners.order(sort: :asc)

    @news_tickers = NewsTicker.filter_by_status
    @news_tickers = @news_tickers.limit(5)
    @news_tickers = @news_tickers.order(sort: :asc)

    @shares = Winner.filter_by_state('published')
    @shares = @shares.limit(5)
    @shares = @shares.order(created_at: :desc)

    @items = Item.filter_by_status
    @items = @items.filter_by_state
    @items = @items.limit(8)
    @items = @items.order(created_at: :desc)
  end
end