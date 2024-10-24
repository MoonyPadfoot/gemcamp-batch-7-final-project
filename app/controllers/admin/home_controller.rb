class Admin::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin

  def index
    render template: 'admin/home/index'
  end

  private

  def authorize_admin
    redirect_to client_root_path unless current_user.admin?
  end
end