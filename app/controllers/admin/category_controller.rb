class Admin::CategoryController < AdminsController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Admin::Category.all
  end

  def new
    @category = Admin::Category.new
  end

  def create
    @category = Admin::Category.new(category_params)

    if @category.save
      flash[:notice] = 'Category created successfully!'
      redirect_to category_index_path
    else
      flash.now[:alert] = 'Category creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category updated successfully!'
      redirect_to category_index_path
    else
      flash.now[:alert] = 'Category update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = 'Category deleted successfully!'
    redirect_to category_index_path
  end

  private

  def set_category
    @category = Admin::Category.find(params[:id])
  end

  def category_params
    params.require(:admin_category).permit(:name)
  end
end