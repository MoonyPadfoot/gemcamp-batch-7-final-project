# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  def new
    cookies.delete :promoter

    if User.exists?(email: params[:promoter]) || params[:promoter].blank?
      cookies[:promoter] = params[:promoter]
    else
      raise ActionController::RoutingError.new('Promoter is non existing. Sumbong mama ;)')
    end

    super
  end

  def create
    super and return unless cookies[:promoter].present?

    super do |resource|
      @promoter = User.find_by(email: cookies[:promoter])
      resource.parent_id = @promoter.id

      cookies.delete :promoter if resource.save
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
