class InvitesController < AdminsController
  def index
    @clients = User.includes(:parent).where(role: :client)
                   .where.not(parent: { id: nil })
                   .page(params[:page]).per(10)
  end
end