class Admin::ItemController < AdminsController
  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]

  def index
    @items = Admin::Item.all
  end

  def new
    @item = Admin::Item.new
  end

  def create
    @item = Admin::Item.new(item_params)

    if @item.save
      flash[:notice] = 'Item created successfully!'
      redirect_to item_index_path
    else
      flash.now[:alert] = 'Item creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully!'
      redirect_to item_index_path
    else
      flash.now[:alert] = 'Item update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @item.destroy
    flash[:notice] = 'Item deleted successfully!'
    redirect_to item_index_path
  end

  def start
    if @item.may_start?
      @item.start!
      flash[:notice] = "Item started!"
    else
      flash[:alert] = "Cannot start item."
    end
    redirect_to item_index_path
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = "Item paused!"
    else
      flash[:alert] = "Cannot pause item."
    end
    redirect_to item_index_path
  end

  def end
    if @item.may_end?
      @item.end!
      flash[:notice] = "Item ended!"
    else
      flash[:alert] = "Cannot end item."
    end
    redirect_to item_index_path
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = "Item canceled!"
    else
      flash[:alert] = "Cannot cancel item."
    end
    redirect_to item_index_path
  end

  private

  def set_item
    @item = Admin::Item.find(params[:id] || params[:item_id])
  end

  def item_params
    params.require(:admin_item).permit(:name, :image, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end