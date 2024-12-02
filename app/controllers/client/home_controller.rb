class Client::HomeController < ClientsController

  def index
    @banners = Banner.all.where(status: :active)
                     .where("online_at <= ?", Time.current)
                     .where("offline_at > ?", Time.current)
                     .order(sort: :asc)
    @news_tickers = NewsTicker.all.where(status: :active).limit(5).order(sort: :asc)
    @shares = Winner.all.where(state: 'published')
                    .order(created_at: :desc)
                    .limit(5)
    @items = Item.all
                 .filter_by_status
                 .filter_by_state
                 .order(created_at: :desc)
                 .limit(8)
  end
end