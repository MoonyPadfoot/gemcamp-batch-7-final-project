class CategoryController < AdminsController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all
                          .page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

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
    if !@category.items.exists?
      @category.destroy
      flash[:notice] = 'Category deleted successfully!'
    else
      flash[:alert] = "Category in use and can't be deleted"
    end
    redirect_to category_index_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end