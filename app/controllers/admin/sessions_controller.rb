class Admin::SessionsController < Devise::SessionsController
  layout 'admin'

  def create
    user = User.admin.find_by(email: params[:admin][:email])
    if user && user.valid_password?(params[:admin][:password])
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, user)
      respond_with resource, location: after_sign_in_path_for(user)
    else
      flash[:alert] = t("devise.failure.invalid", authentication_keys: 'email')
      redirect_to new_admin_session_path
    end
  end
end