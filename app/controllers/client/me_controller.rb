class Client::MeController < ApplicationController
  def index
    render template: 'client/me/index'
  end
end