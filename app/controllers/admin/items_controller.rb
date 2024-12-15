class Admin::ItemsController < AdminsController
  require 'csv'

  before_action :set_item, only: [:edit, :update, :destroy, :start, :pause, :end, :cancel]

  def index
    @items = Item.includes(:categories)
    @items = @items.order(created_at: :desc)
    @items = @items.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            Item.human_attribute_name(:name),
            Item.human_attribute_name(:image),
            Item.human_attribute_name(:status),
            Item.human_attribute_name(:quantity),
            Item.human_attribute_name(:minimum_tickets),
            Item.human_attribute_name(:batch_count),
            Item.human_attribute_name(:online_at),
            Item.human_attribute_name(:offline_at),
            Item.human_attribute_name(:start_at),
            "Categories",
          ]

          Item.includes(:categories).each do |item|
            csv << [
              item.name, item.image_url, item.status, item.quantity, item.minimum_tickets, item.batch_count,
              item.online_at.to_fs, item.offline_at.to_fs,
              item.start_at.to_fs, item.categories.pluck(:name).join(', ')
            ]
          end
        end
        filename = "items_report_#{Time.current.to_fs(:file)}.csv"

        send_data csv_string, filename: filename, type: 'text/csv', disposition: 'attachment'
      }
    end
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      flash[:notice] = 'Item created successfully!'
      redirect_to items_path
    else
      flash.now[:alert] = 'Item creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      flash[:notice] = 'Item updated successfully!'
      redirect_to items_path
    else
      flash.now[:alert] = 'Item update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if !@item.tickets.exists?
      @item.destroy
      flash[:notice] = 'Item deleted successfully!'
    else
      flash[:alert] = "Item has associated tickets and can't be deleted"
    end

    redirect_to items_path
  end

  def start
    if @item.may_start?
      @item.start!
      flash[:notice] = "Item started!"
    else
      flash[:alert] = "Cannot start items."
    end
    redirect_to items_path
  end

  def pause
    if @item.may_pause?
      @item.pause!
      flash[:notice] = "Item paused!"
    else
      flash[:alert] = "Cannot pause items."
    end
    redirect_to items_path
  end

  def end
    if @item.may_end?
      @item.admin_id = current_admin
      
      @item.end!
      flash[:notice] = "Item ended!"
    else
      flash[:alert] = "Cannot end items."
    end
    redirect_to items_path
  end

  def cancel
    if @item.may_cancel?
      @item.cancel!
      flash[:notice] = "Item canceled!"
    else
      flash[:alert] = "Cannot cancel items."
    end
    redirect_to items_path
  end

  private

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
  end

  def item_params
    params.require(:item).permit(:name, :image, :quantity, :minimum_tickets, :batch_count, :online_at, :offline_at, :start_at, :status, category_ids: [])
  end
end