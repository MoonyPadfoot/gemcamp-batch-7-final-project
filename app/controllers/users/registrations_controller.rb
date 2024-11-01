# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create, :update]

  def new
    cookies.delete :promoter

    if params[:promoter].present?
      cookies[:promoter] = params[:promoter]
    end

    super
  end

  def create
    super and return unless cookies[:promoter].present?

    super do |resource|
      if User.exists?(email: cookies[:promoter])
        @promoter = User.find_by(email: cookies[:promoter])
        resource.parent_id = @promoter.id if @promoter

        if resource.save
          cookies.delete :promoter
        else
          flash.now[:alert] = resource.errors.full_messages.join(',')
          render :new and return
        end
      else
        flash.now[:alert] = 'Promoter is non existing'
        super and return
      end
    end

  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number, :coins, :total_deposit, :children_members, :username, :email, :password])
    devise_parameter_sanitizer.permit(:account_update, keys: [:phone_number, :username, :password, :image])
  end
end
