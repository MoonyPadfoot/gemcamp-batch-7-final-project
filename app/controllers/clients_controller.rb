class ClientsController < ApplicationController
  def index
    @clients = User.where(role: :client)
  end
end