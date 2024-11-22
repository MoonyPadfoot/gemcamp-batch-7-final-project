class Admin::InvitesController < AdminsController
  def index
    @clients = User.includes(:parent).where(role: :client)
    @clients = @clients.where.not(parent: { id: nil })
    @clients = @clients.where(parent: { email: params[:email] }) if params[:email].present?
    @clients = @clients.page(params[:page]).per(10)
  end
end