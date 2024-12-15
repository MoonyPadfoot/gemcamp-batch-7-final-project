class Admin::HomeController < AdminsController
  require 'csv'

  def index
    @clients = User.client.includes(:tickets)
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
            'Member total deposit',
            'Total used coins',
            User.human_attribute_name(:total_used_coins),
            User.human_attribute_name(:children_members),
            User.human_attribute_name(:phone_number),
          ]

          User.client.includes(:tickets).each do |client|
            csv << [
              client.parent&.email, client.email, client.total_deposit, client.children.sum(:total_deposit), client.coins,
              client.tickets.sum(:coins), client.children_members, client.phone_number
            ]
          end
        end
        filename = "clients_report_#{Time.current.to_fs(:file)}.csv"

        send_data csv_string, filename: filename, type: 'text/csv', disposition: 'attachment'
      }
    end
  end
end