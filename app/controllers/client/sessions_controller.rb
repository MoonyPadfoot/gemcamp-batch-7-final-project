class Client::SessionsController < Devise::SessionsController
  def create
    user = User.client.find_by(email: params[:client][:email])
    if user && user.valid_password?(params[:client][:password])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      respond_with resource, location: after_sign_in_path_for(user)
    else
      flash[:alert] = t("devise.failure.invalid", authentication_keys: 'email')
      redirect_to new_client_session_path
    end
  end
end