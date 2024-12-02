class Admin::BannersController < AdminsController
  before_action :set_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.all
    @banners = @banners.order(sort: :asc)
    @banners = @banners.page(params[:page]).per(10)
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(banner_params)

    if @banner.save
      flash[:notice] = 'Banner created successfully!'
      redirect_to banners_path
    else
      flash.now[:alert] = 'Banner creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @banner.update(banner_params)
      flash[:notice] = 'Banner updated successfully!'
      redirect_to banners_path
    else
      flash.now[:alert] = 'Banner update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @banner.destroy
      flash[:notice] = 'Banner deleted successfully!'
    else
      flash[:alert] = "Banner in use and can't be deleted"
    end
    redirect_to banners_path
  end

  private

  def set_banner
    @banner = Banner.find(params[:id])
  end

  def banner_params
    params.require(:banner).permit(:preview, :status, :online_at, :offline_at, :sort)
  end
end