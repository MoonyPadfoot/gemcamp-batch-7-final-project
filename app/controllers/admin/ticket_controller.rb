class Admin::TicketController < AdminsController
  before_action :set_ticket, only: :cancel

  def index
    @tickets = Ticket.all
                     .page(params[:page]).per(10)
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

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end
end