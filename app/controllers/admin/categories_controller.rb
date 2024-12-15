class Admin::CategoriesController < AdminsController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.order(sort: :asc)
    @categories = @categories.page(params[:page]).per(10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = t('flash.categories.create.success')
      redirect_to categories_path
    else
      flash.now[:alert] = t('flash.categories.create.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      flash[:notice] = t('flash.categories.update.success')
      redirect_to categories_path
    else
      flash.now[:alert] = t('flash.categories.update.failure')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if !@category.items.exists?
      @category.destroy
      flash[:notice] = t('flash.categories.destroy.success')
    else
      flash[:alert] = t('flash.categories.destroy.failure')
    end
    redirect_to categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :sort)
  end
end