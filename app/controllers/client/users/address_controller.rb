class Client::Users::AddressController < ClientsController
  # before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index

  end

  def new
    @address = Client::Address.new
  end

  def create
    @address = Client::Address.new(address_params)

    @address.user = current_client
    if @address.save
      flash[:notice] = 'Address created successfully!'
      redirect_to address_index_path
    else
      flash.now[:alert] = @address.errors.full_messages.join(', ')
      render :new, status: :unprocessable_entity
    end
  end

  def address_params
    params.require(:client_address).permit(:barangay_id, :city_id, :province_id, :region_id, :is_default, :remark, :phone_number, :street_address, :name, genre_ids: [])
  end
end