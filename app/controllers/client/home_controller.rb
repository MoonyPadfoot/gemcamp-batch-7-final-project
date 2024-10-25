class Client::HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_client

  def index
    render template: 'client/home/index'
  end

  private

  def authorize_client
    raise ActionController::RoutingError.new('Not Found') if current_user.admin?
  end
end