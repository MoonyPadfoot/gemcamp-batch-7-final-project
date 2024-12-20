class Admin::OffersController < AdminsController
  helper :offers

  before_action :set_offer, only: [:edit, :update, :destroy]

  def index
    @offers = Offer.order(created_at: :desc)
    @offers = @offers.filter_by_status(params[:status]) if params[:status].present?
    @offers = @offers.page(params[:page]).per(10)
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      flash[:notice] = 'Offer created successfully!'
      redirect_to offers_path
    else
      flash.now[:alert] = 'Offer creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @offer.update(offer_params)
      flash[:notice] = 'Offer updated successfully!'
      redirect_to offers_path
    else
      flash.now[:alert] = 'Offer update failed'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @offer.destroy
      flash[:notice] = 'Offer deleted successfully!'
    else
      flash[:alert] = "Offer in use and can't be deleted"
    end
    redirect_to offers_path
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:name, :image, :coin, :amount, :status, :genre)
  end
end