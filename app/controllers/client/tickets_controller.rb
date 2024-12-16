class Client::TicketsController < ClientsController
  before_action :authenticate_client!, only: :create

  def create
    item_id = params[:ticket][:item_id]
    ticket_count = params[:ticket][:ticket_count].to_i

    current_client.ticket_count = ticket_count
    Rails.logger.debug "Current Client: #{current_client.ticket_count}"

    unless current_client.valid?(:purchase)
      flash[:alert] = current_client.errors.full_messages.join(", ")
      redirect_to shops_path and return
    end

    tickets = []

    ticket_count.times do
      ticket = Ticket.new(ticket_params)
      ticket.user = current_client
      tickets << ticket
    end

    ActiveRecord::Base.transaction do
      if tickets.all?(&:save)
        flash[:notice] = "#{'Ticket'.pluralize(ticket_count)} successfully purchased."
      else
        flash[:alert] = "#{'Ticket'.pluralize(ticket_count)} purchased failed. Please try again later."
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