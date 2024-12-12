class Admin::Users::Orders::MemberLevelController < AdminsController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def new
    @user = User.client.find(params[:client_id])
    @order = Order.new
    render :template => "admin/users/orders/new"
  end

  def create
    @user = User.client.find(params[:client_id])
    @order = Order.new(params.require(:order).permit(:coin, :genre))
    @order.user = User.client.find(params[:client_id])

    ActiveRecord::Base.transaction do
      if @order.save
        order_pay
        flash[:notice] = "Coin for #{@order.user.email} added!"
        redirect_to admin_root_path
      else
        flash[:alert] = "Coin failed to add: #{ @order.errors.full_messages.to_sentence }"
        render template: "admin/users/orders/new", status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def order_pay
    if @order.may_pay?
      @order.pay!
    else
      flash[:alert] = "Coin failed to add: #{ @order.errors.full_messages.to_sentence }"
      render template: "admin/users/orders/new", status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
  end
end