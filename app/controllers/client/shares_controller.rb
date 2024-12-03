class Client::SharesController < ClientsController
  def index
    @shares = Winner.includes(:user).filter_by_state('published')

    @banners = Banner.filter_by_status
    @banners = @banners.filter_by_online_at
    @banners = @banners.filter_by_offline_at
    @banners = @banners.order(sort: :asc)

    @news_tickers = NewsTicker.filter_by_status.limit(5)
  end
end