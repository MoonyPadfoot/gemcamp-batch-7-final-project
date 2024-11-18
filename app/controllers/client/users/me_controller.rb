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
    @winning_histories = Winner.includes(:user).includes(:ticket).where(users: { id: current_client.id }, tickets: { state: :won })
                               .page(params[:page]).per(10)
    get_addresses
  end

  def invitation_history
    @invitation_histories = User.includes(:children).where(parent_id: current_user.id)
                                .page(params[:page]).per(10)
  end

  def claim_prize
    @winner = Winner.find(params[:winner][:id])

    if @winner.may_claim?
      @winner.update(params.require(:winner).permit(:address_id))
      @winner.claim!
      flash[:notice] = 'Prize claimed successfully!'
      redirect_to me_winning_history_path
    else
      flash.now[:alert] = "Prize failed to claim: #{ @winner.errors.full_messages.to_sentence }"
      winning_history
      get_addresses
      render :winning_history, status: :unprocessable_entity
    end
  end

  def share_feedback
    @winner = Winner.find(params[:winner][:id])

    @winner.update(params.require(:winner).permit(:comment, :picture))
    if @winner.may_share? && @winner.valid?(:share_feedback)
      @winner.share!
      flash[:notice] = 'Feedback shared successfully!'
      redirect_to me_winning_history_path
    else
      flash.now[:alert] = "Feedback failed to share: #{ @winner.errors.full_messages.to_sentence }"
      winning_history
      get_addresses
      render :winning_history, status: :unprocessable_entity
    end
  end

  private

  def get_addresses
    @addresses = Client::Address.includes(:user).where(users: { id: current_client.id }).order(is_default: :desc)
  end

end