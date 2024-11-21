class Client::TicketsController < ClientsController
  before_action :authenticate_client!, only: :create

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

    ActiveRecord::Base.transaction do
      if tickets.all?(&:save)
        flash[:notice] = "Ticket(s) successfully purchased."
      else
        flash[:alert] = "Ticket(s) purchased failed. Please try again later."
        raise ActiveRecord::Rollback
      end
    end

    redirect_to lottery_path(item_id)
  end

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end

  def ticket_params
    params.require(:ticket).permit(:item_id, :batch_count)
  end
end