class Client::MeController < ClientsController
  def index
    render template: 'client/me/index'
  end
end