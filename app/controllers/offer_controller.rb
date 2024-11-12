class OfferController < AdminsController

  def index
    @offers = Offer.all
                   .page(params[:page]).per(10)
  end

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      flash[:notice] = 'Offer created successfully!'
      redirect_to offer_index_path
    else
      flash.now[:alert] = 'Offer creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_offer
    @offer = Offer.find(params[:id])
  end

  def offer_params
    params.require(:offer).permit(:name, :image, :coin, :amount, :status)
  end
end