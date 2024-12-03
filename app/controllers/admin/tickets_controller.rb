class Admin::TicketsController < AdminsController
  require 'csv'

  before_action :authenticate_admin!, only: :index
  before_action :set_ticket, only: :cancel

  def index
    @tickets = Ticket.order(created_at: :desc)
    @tickets = @tickets.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @tickets = @tickets.filter_by_item_name(params[:item_name]) if params[:item_name].present?
    @tickets = @tickets.filter_by_email(params[:email]) if params[:email].present?
    @tickets = @tickets.filter_by_created_at(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    @tickets = @tickets.filter_by_state(params[:state]) if params[:state].present?
    @tickets = @tickets.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            'Item name',
            Ticket.human_attribute_name(:serial_number),
            'Email',
            Ticket.human_attribute_name(:state),
            Ticket.human_attribute_name(:created_at),
          ]

          @tickets.each do |ticket|
            csv << [
              ticket.item.name, ticket.serial_number, ticket.user.email, ticket.state, ticket.created_at.strftime("%Y/%m/%d %I:%M %p")
            ]
          end
        end
        render plain: csv_string
      }
    end
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