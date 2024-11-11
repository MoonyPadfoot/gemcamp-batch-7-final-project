class WinnerController < AdminsController

  def index
    @winners = Winner.all
  end
end