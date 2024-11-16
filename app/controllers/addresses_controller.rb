class AddressesController < ApplicationController
  def show
    @address = Client::Address.find(params[:id])

    render json: {
      name: @address.name,
      is_default: @address.is_default,
      genre: @address.genre,
      phone_number: @address.phone_number,
      remark: @address.remark,
      street_address: @address.street_address,
      barangay: @address.barangay,
      city: @address.city,
      province: @address.province
    }
  end
end