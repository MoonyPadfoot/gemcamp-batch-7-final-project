class Admin::InvitesController < AdminsController
  require 'csv'

  def index
    @clients = User.client.includes(:parent)
    @clients = @clients.where.not(parent: { id: nil })
    @clients = @clients.where(parent: { email: params[:email] }) if params[:email].present?
    @clients = @clients.order(created_at: :desc)
    @clients = @clients.page(params[:page]).per(10)

    respond_to do |format|
      format.html
      format.csv {
        csv_string = CSV.generate do |csv|
          csv << [
            'Parent email',
            User.human_attribute_name(:email),
            User.human_attribute_name(:total_deposit),
            'Member total deposits',
            'Coins',
            'Total used coins',
            User.human_attribute_name(:children_members),
            User.human_attribute_name(:created_at),
          ]

          @clients.each do |client|
            csv << [
              client.parent&.email, client.email, client.total_deposit, client.children.sum(:total_deposit), client.coins,
              Ticket.includes(:user).where(users: { id: client }).sum(:coins), client.children_members, client.created_at.strftime("%Y/%m/%d %I:%M %p")
            ]
          end
        end
        render plain: csv_string
      }
    end
  end
end