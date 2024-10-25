class Admin::HomeController < ApplicationController
  before_action :authenticate_admin!
  before_action :authorize_admin

  def index
    render template: 'admin/home/index'
  end

  private

  def authorize_admin
    raise ActionController::RoutingError.new('Not Found') if current_user.client?
  end

  def current_user
    warden.authenticate(scope: :admin)
  end
end