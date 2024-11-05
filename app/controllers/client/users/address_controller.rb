class Client::Users::AddressController < ClientsController

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
      @regions = Address::Region.all
      @provinces = @address.region.provinces if @address.region
      @cities = @address.province.cities if @address.province
      @barangays = @address.city.barangays if @address.city

      render :new, status: :unprocessable_entity
    end
  end

  def address_params
    params.require(:client_address).permit(:barangay_id, :city_id, :province_id, :region_id, :is_default, :remark, :phone_number, :street_address, :name, genre_ids: [])
  end
end