class ClientsController < ApplicationController
  before_action :authenticate_client!

  def after_sign_out_path_for(resource_or_scope)
    new_client_session_path
  end
end