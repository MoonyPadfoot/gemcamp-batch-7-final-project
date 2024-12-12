class Api::V1::ProvincesController < ApplicationController

  def index
    region = Address::Region.find(params[:region_id])
    provinces = if region
                  region.provinces
                else
                  Address::Province.all
                end

    render json: provinces
  end

  def show
    province = Address::Province.find(params[:id])
    render json: province
  end
end