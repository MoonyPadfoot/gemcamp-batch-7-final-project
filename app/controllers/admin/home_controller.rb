class Admin::HomeController < AdminsController
  def index
    @clients = User.where(role: :client)
                   .page(params[:page]).per(10)
  end
end