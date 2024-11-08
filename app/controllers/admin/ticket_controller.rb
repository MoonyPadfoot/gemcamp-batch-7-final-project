class Admin::TicketController < AdminsController

  def index
    @tickets = Ticket.all
                     .page(params[:page]).per(10)
  end
end