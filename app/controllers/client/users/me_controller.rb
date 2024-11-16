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

    @winner = Winner.new
    @addresses = Client::Address.order(is_default: :desc)
  end

  def invitation_history
    @invitation_histories = User.includes(:children).where(parent_id: current_user.id)
                                .page(params[:page]).per(10)
  end

  def claim_prize
    @winner = Winner.includes(:item).where(items: { id: params[:winner][:item_id] }, ticket_id: params[:winner][:ticket_id]).first

    if @winner.update(params.require(:winner).permit(:address_id)) && @winner.may_claim?
      @winner.claim!
      flash[:notice] = 'Prize claimed successfully!'
      redirect_to me_winning_history_path
    else
      winning_history
      flash.now[:alert] = 'Prize failed to claim'
      render :winning_history, status: :unprocessable_entity
    end
  end

  def share_feedback
    @winner = Winner.includes(:item).where(items: { id: params[:winner][:item_id] }, ticket_id: params[:winner][:ticket_id]).first

    if @winner.update(params.require(:winner).permit(:comment, :picture)) && @winner.may_share?
      @winner.share!
      flash[:notice] = 'Feedback shared successfully!'
      redirect_to me_winning_history_path
    else
      flash.now[:alert] = "Feedback failed to share: #{ @winner.errors.full_messages.to_sentence }"
      winning_history
      render :winning_history, status: :unprocessable_entity
    end
  end

end