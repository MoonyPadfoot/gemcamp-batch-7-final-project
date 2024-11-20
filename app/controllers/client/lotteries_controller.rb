class Client::LotteriesController < ClientsController
  before_action :authenticate_client!, except: [:show, :index]
  before_action :set_item, only: [:show, :allow_starting_items]
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

    ticket_count = Ticket.includes(:item).where(batch_count: @item.batch_count, items: { id: @item.id }).count
    @ticket_percentage = ticket_count.to_f / @item.minimum_tickets * 100
    @user_tickets = Ticket.includes(:item).where(user: current_client, batch_count: @item.batch_count, items: { id: @item.id })
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def allow_starting_items
    unless @item.starting?
      redirect_to lotteries_path, alert: "You are not authorized to view this item."
    end
  end
end