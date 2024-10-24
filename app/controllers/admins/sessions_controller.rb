class Admins::SessionsController < Devise::SessionsController
  def create
    super do |user|
      unless user.admin?
        sign_out user
        flash[:alert] = "You are not authorized as an admin."
        redirect_to new_admin_session_path and return
      end
    end
  end
end
