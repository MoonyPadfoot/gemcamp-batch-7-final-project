class Client::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client

  def index
    render template: 'client/home/index'
  end

  private

  def authorize_client
    redirect_to admin_root_path unless current_user.admin?
  end
end