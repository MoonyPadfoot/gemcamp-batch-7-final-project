class Client::HomeController < ClientsController
  def index #refactor
    render template: 'client/home/index'
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