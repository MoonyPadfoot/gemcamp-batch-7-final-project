# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || custom_redirect_path
  end

  private

  def custom_redirect_path
    if current_user.admin?
      admin_root_path
    else
      client_root_path
    end
  end
end
