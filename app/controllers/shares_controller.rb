class SharesController < ApplicationController
  before_action :authorize_client, only: :index

  def index
    @shares = Winner.all.where(state: 'published')
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