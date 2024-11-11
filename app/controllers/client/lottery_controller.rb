class Client::LotteryController < ApplicationController
  before_action :authorize_client, :set_item, only: [:show, :allow_starting_items]
  before_action :allow_starting_items, only: :show

  def index
    @categories = Category.all
    @items = Item.all
                        .filter_by_status
                        .filter_by_category(params[:category])
                        .filter_by_state
                        .page(params[:page]).per(4)
  end

  def show
    @ticket = Ticket.new
  end

  def after_sign_out_path_for(resource_or_scope)
    new_client_session_path
  end

  private

  def authorize_client
    if current_user&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def current_user
    warden.authenticate(scope: :client)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def allow_starting_items
    unless @item.starting?
      redirect_to lottery_index_path, alert: "You are not authorized to view this item."
    end
  end
end