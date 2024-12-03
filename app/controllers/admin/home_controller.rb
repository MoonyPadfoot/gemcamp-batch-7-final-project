class Admin::HomeController < AdminsController
  require 'csv'

  def index
    @clients = User.includes(:tickets).where(role: :client)
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

          @clients.each do |client|
            csv << [
              client.parent&.email, client.email, client.total_deposit, client.children.sum(:total_deposit), client.coins,
              Ticket.includes(:user).where(users: { id: client }).sum(:coins), client.children_members, client.phone_number
            ]
          end
        end
        render plain: csv_string
      }
    end
  end
end