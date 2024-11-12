class WinnerController < AdminsController
  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.all
    @winners = @winners.filter_by_serial_number(params[:serial_number]) unless params[:serial_number].blank?
    @winners = @winners.filter_by_email(params[:email]) unless params[:email].blank?
    @winners = @winners.filter_by_created_at(params[:start_date], params[:end_date]) unless params[:start_date].blank? && params[:end_date].blank?
    @winners = @winners.filter_by_state(params[:state]) unless params[:state].blank?
    @winners = @winners.page(params[:page]).per(10)
  end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = "Submitted!"
    else
      flash[:alert] = "Cannot submit."
    end
    redirect_to winner_index_path
  end

  def pay
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = "Paid!"
    else
      flash[:alert] = "Cannot pay."
    end
    redirect_to winner_index_path
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = "Shipped!"
    else
      flash[:alert] = "Cannot ship."
    end
    redirect_to winner_index_path
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = "Delivered!"
    else
      flash[:alert] = "Cannot deliver."
    end
    redirect_to winner_index_path
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = "Published!"
    else
      flash[:alert] = "Cannot publish."
    end
    redirect_to winner_index_path
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = "Unpublished!"
    else
      flash[:alert] = "Cannot unpublish."
    end
    redirect_to winner_index_path
  end

  private

  def set_winner
    @winner = Winner.find(params[:winner_id])
  end
end