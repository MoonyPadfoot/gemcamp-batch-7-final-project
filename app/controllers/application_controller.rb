class ApplicationController < ActionController::Base
  protected

  def after_sign_in_path_for(resource)
    if resource.client?
      client_root_path # Redirect to client's home
    elsif resource.admin?
      admin_root_path # Redirect to admin's home
    else
      super # Fallback for any other roles (if applicable)
    end
  end
end
