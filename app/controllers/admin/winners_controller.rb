class Admin::WinnersController < AdminsController
  require 'csv'

  before_action :set_winner, only: [:submit, :pay, :ship, :deliver, :publish, :remove_publish]

  def index
    @winners = Winner.order(created_at: :desc)
    @winners = @winners.filter_by_serial_number(params[:serial_number]) if params[:serial_number].present?
    @winners = @winners.filter_by_email(params[:email]) if params[:email].present?
    @winners = @winners.filter_by_created_at(params[:start_date], params[:end_date]) if params[:start_date].present? && params[:end_date].present?
    @winners = @winners.filter_by_state(params[:state]) if params[:state].present?
    @winners = @winners.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            Ticket.human_attribute_name(:serial_number),
            User.human_attribute_name(:email),
            'Address',
            'Batch count',
            Winner.human_attribute_name(:state),
            Winner.human_attribute_name(:price),
            Winner.human_attribute_name(:paid_at),
            'Admin',
            Winner.human_attribute_name(:picture),
            Winner.human_attribute_name(:comment),
            Winner.human_attribute_name(:created_at),
          ]

          @winners.each do |winner|
            csv << [
              winner.ticket.serial_number, winner.user.email,
              winner.address.nil? ? 'Address not available' :
                "#{winner.address.street_address}, #{winner.address.barangay.name}, #{winner.address.city.name} City, #{winner.address.province.name}",
              winner.item_batch_count, winner.state, winner.price, winner.paid_at&.strftime("%Y/%m/%d %I:%M %p"),
              winner.admin&.email, winner&.picture_url, winner.comment, winner.created_at.strftime("%Y/%m/%d %I:%M %p")
            ]
          end
        end
        render plain: csv_string
      }
    end
  end

  def claim
    if @winner.may_claim?
      @winner.claim!
      flash[:notice] = "Claimed!"
    else
      flash[:alert] = "Cannot claimed."
    end
    redirect_to winners_path(page: params[:page])
  end

  def submit
    if @winner.may_submit?
      @winner.submit!
      flash[:notice] = "Submitted!"
    else
      flash[:alert] = "Cannot submit."
    end
    redirect_to winners_path(page: params[:page])
  end

  def pay
    if @winner.may_pay?
      @winner.pay!
      flash[:notice] = "Paid!"
    else
      flash[:alert] = "Cannot pay."
    end
    redirect_to winners_path(page: params[:page])
  end

  def ship
    if @winner.may_ship?
      @winner.ship!
      flash[:notice] = "Shipped!"
    else
      flash[:alert] = "Cannot ship."
    end
    redirect_to winners_path(page: params[:page])
  end

  def deliver
    if @winner.may_deliver?
      @winner.deliver!
      flash[:notice] = "Delivered!"
    else
      flash[:alert] = "Cannot deliver."
    end
    redirect_to winners_path(page: params[:page])
  end

  def publish
    if @winner.may_publish?
      @winner.publish!
      flash[:notice] = "Published!"
    else
      flash[:alert] = "Cannot publish."
    end
    redirect_to winners_path(page: params[:page])
  end

  def remove_publish
    if @winner.may_remove_publish?
      @winner.remove_publish!
      flash[:notice] = "Unpublished!"
    else
      flash[:alert] = "Cannot unpublish."
    end
    redirect_to winners_path(page: params[:page])
  end

  private

  def set_winner
    @winner = Winner.find(params[:winner_id])
  end
end