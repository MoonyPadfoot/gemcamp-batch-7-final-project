class Client::Users::MeController < ClientsController
  def index; end

  def order_history
    @order_histories = Order.includes(:user).where(users: { id: current_client.id })
                            .page(params[:page]).per(10)
  end

  def lottery_history
    @lottery_histories = Ticket.includes(:user).where(users: { id: current_client.id })
                               .page(params[:page]).per(10)
  end

  def winning_history
    @winning_histories = Ticket.includes(:user).where(users: { id: current_client.id }, state: :won)
                               .page(params[:page]).per(10)
  end

  def invitation_history
    @invitation_histories = User.includes(:children).where(parent_id: current_user.id)
                                .page(params[:page]).per(10)
  end
end