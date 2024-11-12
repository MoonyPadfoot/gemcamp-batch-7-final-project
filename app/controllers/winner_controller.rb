class WinnerController < AdminsController

  def index
    @winners = Winner.all
                     .page(params[:page]).per(10)
  end
end