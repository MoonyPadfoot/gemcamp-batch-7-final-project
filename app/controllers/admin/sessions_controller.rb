class Admin::SessionsController < Devise::SessionsController
  def create
    user = User.admin.find_by(email: params[:admin][:email])
    if user && user.valid_password?(params[:admin][:password])
      sign_in(resource_name, user)
      redirect_to admin_root_path
    else
      flash[:alert] = "You are not allowed to access this part of the site"
      redirect_to new_admin_session_path
    end
  end
end