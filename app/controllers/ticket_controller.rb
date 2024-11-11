class TicketController < ApplicationController
  before_action :authenticate_admin!, only: :index
  before_action :authorize_admin, only: :index
  before_action :authenticate_client!, only: :create
  before_action :authorize_client, only: :create
  before_action :set_ticket, only: :cancel

  def index
    @tickets = Ticket.all
    @tickets = @tickets.filter_by_serial_number(params[:serial_number]) unless params[:serial_number].blank?
    @tickets = @tickets.filter_by_item_name(params[:item_name]) unless params[:item_name].blank?
    @tickets = @tickets.filter_by_email(params[:email]) unless params[:email].blank?
    @tickets = @tickets.filter_by_created_at(params[:start_date], params[:end_date]) unless params[:start_date].blank? && params[:end_date].blank?
    @tickets = @tickets.filter_by_state(params[:state]) unless params[:state].blank?
    @tickets = @tickets.page(params[:page]).per(10)
  end

  def create
    item_id = params[:ticket][:item_id]
    ticket_count = params[:ticket][:ticket_count].to_i

    if current_client.coins == 0
      flash[:alert] = "Ticket(s) purchased failed. Coins insufficient."
      redirect_to lottery_path(item_id) and return
    end

    tickets = []

    ticket_count.times do
      ticket = Ticket.new(ticket_params)
      ticket.user = current_client
      tickets << ticket
    end

    if tickets.all?(&:save)
      flash[:notice] = "Ticket(s) successfully purchased."
    else
      flash[:alert] = "Ticket(s) purchased failed. Please try again later."
    end

    redirect_to lottery_path(item_id)
  end

  def cancel
    if @ticket.may_cancel?
      @ticket.cancel!
      flash[:notice] = "Item cancelled!"
    else
      flash[:alert] = "Cannot cancel ticket."
    end
    redirect_to ticket_index_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_client_session_path
  end

  private

  def authorize_client
    if current_client&.admin?
      sign_out(current_admin)
      redirect_to new_client_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def authorize_admin
    if current_admin&.client?
      sign_out(current_client)
      redirect_to new_admin_session_path, alert: 'You are not allowed to access this part of the site'
    end
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def ticket_params
    params.require(:ticket).permit(:item_id, :batch_count)
  end
end