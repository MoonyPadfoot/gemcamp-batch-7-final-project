class Client::HomeController < ClientsController
  before_action :authenticate_client!, except: :index
  def index
    @banners = Banner.active
    @banners = @banners.online_at(Time.current)
    @banners = @banners.online_at(Time.current)
    @banners = @banners.order(sort: :asc)

    @news_tickers = NewsTicker.active
    @news_tickers = @news_tickers.limit(5)
    @news_tickers = @news_tickers.order(sort: :asc)

    @shares = Winner.published
    @shares = @shares.limit(5)
    @shares = @shares.order(created_at: :desc)

    @items = Item.active
    @items = @items.starting
    @items = @items.limit(8)
    @items = @items.order(created_at: :desc)
  end
end