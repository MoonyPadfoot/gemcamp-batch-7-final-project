class Client::SharesController < ClientsController
  def index
    @shares = Winner.includes(:user).where(user: current_client).published

    @banners = Banner.active
    @banners = @banners.online_at(Time.current)
    @banners = @banners.online_at(Time.current)
    @banners = @banners.order(sort: :asc)

    @news_tickers = NewsTicker.active.limit(5)
  end
end