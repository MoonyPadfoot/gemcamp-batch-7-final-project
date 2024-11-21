class Client::HomeController < ClientsController

  def index
    @banners = Banner.all.where(status: :active)
                     .where("online_at <= ?", Time.current)
                     .where("offline_at > ?", Time.current)
    @news_tickers = NewsTicker.all.where(status: :active).limit(5)
  end
end