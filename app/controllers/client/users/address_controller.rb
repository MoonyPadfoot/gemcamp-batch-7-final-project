class Client::Users::AddressController < ClientsController
  before_action :set_address, only: [:edit, :update, :destroy]

  def index
    @addresses = Client::Address.includes(:user).where(users: { id: current_client }).order(is_default: :desc)
  end

  def new
    @address = Client::Address.new
    @regions = Address::Region.all
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

      flash.now[:alert] = "Address creation failed: #{ @address.errors.full_messages.join(', ') }"

      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @regions = Address::Region.all
    @provinces = @address.region.provinces if @address.region
    @cities = @address.province.cities if @address.province
    @barangays = @address.city.barangays if @address.city
  end

  def update
    if @address.update(address_params)
      flash[:notice] = 'Address updated successfully!'
      redirect_to address_index_path
    else
      @regions = Address::Region.all
      @provinces = @address.region.provinces if @address.region
      @cities = @address.province.cities if @address.province
      @barangays = @address.city.barangays if @address.city

      flash.now[:alert] = "Address update failed: #{ @address.errors.full_messages.join(',') }"

      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    flash[:notice] = 'Address deleted successfully!'
    redirect_to address_index_path
  end

  private

  def set_address
    @address = Client::Address.find(params[:id])
  end

  def address_params
    params.require(:client_address).permit(:barangay_id, :city_id, :province_id, :region_id, :is_default, :remark, :phone_number, :street_address, :name, :genre)
  end
end