class Client::SessionsController < Devise::SessionsController
  def create
    user = User.client.find_by(email: params[:client][:email])
    if user && user.valid_password?(params[:client][:password])
      sign_in(resource_name, user)
      redirect_to client_root_path
    else
      flash[:alert] = "You are not allowed to access this part of the site"
      redirect_to new_client_session_path
    end
  end
end