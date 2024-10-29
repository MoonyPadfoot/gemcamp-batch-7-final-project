class AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :authorize_admin

  private

  def authorize_admin
    if current_user&.client?
      sign_out(current_client)
      redirect_to new_admin_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def current_user
    warden.authenticate(scope: :admin)
  end
end