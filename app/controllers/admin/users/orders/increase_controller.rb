class Admin::Users::Orders::IncreaseController < AdminsController
  def new
    @user = User.client.find(params[:client_id])
    @order = Order.new
    render :template => "admin/users/orders/new"
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :genre, :remarks))
    @order.user = User.client.find(params[:client_id])

    ActiveRecord::Base.transaction do
      if @order.valid?(:balance_operate) && @order.save
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