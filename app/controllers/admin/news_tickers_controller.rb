class Admin::NewsTickersController < AdminsController
  before_action :set_news_ticker, only: [:edit, :update, :destroy]

  def index
    @news_tickers = NewsTicker.all
                              .order(sort: :asc)
                              .page(params[:page]).per(10)
  end

  def new
    @news_ticker = NewsTicker.new
  end

  def create
    @news_ticker = NewsTicker.new(news_ticker_params)

    if @news_ticker.save
      flash[:notice] = 'News created successfully!'
      redirect_to news_tickers_path
    else
      flash.now[:alert] = 'News creation failed'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @news_ticker.update(news_ticker_params)
      flash[:notice] = 'News updated successfully!'
      redirect_to news_tickers_path
    else
      flash.now[:alert] = 'News update failed'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if @news_ticker.destroy
      flash[:notice] = 'News deleted successfully!'
    else
      flash[:alert] = "News in use and can't be deleted"
    end
    redirect_to news_tickers_path
  end

  private

  def set_news_ticker
    @news_ticker = NewsTicker.find(params[:id])
  end

  def news_ticker_params
    params.require(:news_ticker).permit(:content, :status, :admin_id, :sort)
  end
end