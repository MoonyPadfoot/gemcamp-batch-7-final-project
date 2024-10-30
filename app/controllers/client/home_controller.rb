class Client::HomeController < ClientsController
  def index #refactor
    render template: 'client/home/index'
  end
end