class Admin::TicketsController < ApplicationController
  before_action :authenticate_admin!, only: :index
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

  def cancel
    if @ticket.may_cancel?
      @ticket.cancel!
      flash[:notice] = "Item cancelled!"
    else
      flash[:alert] = "Cannot cancel tickets."
    end
    redirect_to tickets_path
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def ticket_params
    params.require(:ticket).permit(:item_id, :batch_count)
  end
end