class Client::Users::InvitePeopleController < ClientsController
  def index
    @promoter_email = current_client&.email
    @invite_url = "#{request.host}/users/sign_up?promoter=#{@promoter_email}"

    qrcode = RQRCode::QRCode.new(@invite_url)
    @svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: 7,
      standalone: true,
      use_path: true
    )
  end
end