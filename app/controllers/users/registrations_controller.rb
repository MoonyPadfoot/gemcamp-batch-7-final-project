# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  def new
    cookies[:promoter] ||= params[:promoter] if User.client.exists?(email: params[:promoter])
    super
  end

  def create
    if User.client.exists?(email: cookies[:promoter])
      @promoter = User.client.find_by(email: cookies[:promoter])
      build_resource(sign_up_params)
      resource.parent = @promoter
      resource.member_level = MemberLevel.first

      if resource.save
        cookies.delete(:promoter)
        set_flash_message!(:notice, :signed_up) if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        respond_with resource
      end
    else
      super
    end
  end

  protected

  def after_update_path_for(resource)
    flash[:notice] = "Account successfully updated!"
    me_index_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:promoter_name, :phone_number, :coins, :total_deposit, :children_members, :username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :username, :password, :image])
  end
end
