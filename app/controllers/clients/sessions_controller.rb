class Clients::SessionsController < Devise::SessionsController
  def create
    super do |user|
      unless user.client?
        sign_out user
        flash[:alert] = "You are not authorized as a client."
        redirect_to new_client_session_path and return
      end
    end
  end
end