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

          User.client.includes(:parent).where.not(parent: { id: nil }).each do |client|
            csv << [
              client.parent&.email, client.email, client.total_deposit, client.children.sum(:total_deposit), client.coins,
              client.tickets.sum(:coins), client.children_members, client.created_at.to_fs
            ]
          end
        end
        filename = "invites_report_#{Time.current.to_fs(:file)}.csv"

        send_data csv_string, filename: filename, type: 'text/csv', disposition: 'attachment'
      }
    end
  end
end