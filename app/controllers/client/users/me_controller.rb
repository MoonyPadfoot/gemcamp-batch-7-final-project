class Client::Users::MeController < ClientsController
  def index; end

  def order_history
    @order_histories = Order.includes(:user)
    @order_histories = @order_histories.where(users: current_client)
    @order_histories = @order_histories.order(created_at: :desc)
    @order_histories = @order_histories.page(params[:page]).per(10)
  end

  def lottery_history
    @lottery_histories = Ticket.includes(:user)
    @lottery_histories = @lottery_histories.where(users: current_client)
    @lottery_histories = @lottery_histories.order(created_at: :desc)
    @lottery_histories = @lottery_histories.page(params[:page]).per(10)
  end

  def winning_history
    get_winning_histories
    get_addresses
  end

  def invitation_history
    @invitation_histories = User.client.includes(:children)
    @invitation_histories = @invitation_histories.where(parent: current_client)
    @invitation_histories = @invitation_histories.order(created_at: :desc)
    @invitation_histories = @invitation_histories.page(params[:page]).per(10)
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
      get_winning_histories
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
      get_winning_histories
      get_addresses
      render :winning_history, status: :unprocessable_entity
    end
  end

  private

  def get_addresses
    @addresses = Client::Address.includes(:user)
    @addresses = @addresses.where(users: current_client)
    @addresses = @addresses.order(is_default: :desc)
  end

  def get_winning_histories
    @winning_histories = Winner.includes(:user)
    @winning_histories = @winning_histories.where(users: current_client)
    @winning_histories = @winning_histories.order(created_at: :desc)
    @winning_histories = @winning_histories.page(params[:page]).per(10)
  end

end