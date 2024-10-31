class Client::Users::InvitePeopleController < ClientsController
  def index
    @promoter_email = current_client&.email
    @invite_url = "http://client.com:3013/users/sign_up?promoter=#{@promoter_email}"

    qrcode = RQRCode::QRCode.new(@invite_url)
    @svg = qrcode.as_svg(
      offset: 0,
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 6,
      standalone: true
    )
  end
end