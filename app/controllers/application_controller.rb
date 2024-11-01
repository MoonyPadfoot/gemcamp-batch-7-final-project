class ApplicationController < ActionController::Base
  def after_sign_out_path_for(resource_or_scope)
    case request.host
    when "client.com"
      new_client_session_path
    when "admin.com"
      new_admin_session_path
    end
  end

end
