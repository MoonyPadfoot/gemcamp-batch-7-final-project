class Admin::HomeController < AdminsController
  def index
    @clients = User.where(role: :client)
  end
end