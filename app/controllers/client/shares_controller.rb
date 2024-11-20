class Client::SharesController < ClientsController
  def index
    @shares = Winner.all.where(state: 'published')
  end
end