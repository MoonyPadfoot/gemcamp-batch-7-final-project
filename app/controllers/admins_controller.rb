class AdminsController < ApplicationController
  def index
    @admins = User.where(role: :admin)
  end
end