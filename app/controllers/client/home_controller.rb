class Client::HomeController < ApplicationController
  before_action :authorize_client

  def index
  end

  def after_sign_out_path_for(resource_or_scope)
    new_client_session_path
  end

  private

  def authorize_client
    if current_user&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def current_user
    warden.authenticate(scope: :client)
  end
end