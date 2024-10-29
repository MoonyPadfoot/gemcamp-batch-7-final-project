class Admin::HomeController < AdminsController
  def index
    render template: 'admin/home/index'
  end
end