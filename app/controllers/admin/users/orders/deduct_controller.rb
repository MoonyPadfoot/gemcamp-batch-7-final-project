class Admin::Users::Orders::DeductController < AdminsController
  def new
    @user = User.client.find(params[:client_id])
    @order = Order.new
    render :template => "admin/users/orders/new"
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :genre, :remarks))
    @order.user = User.client.find(params[:client_id])

    if @order.user.coins == 0
      flash[:alert] = "Coin insufficient and can't be deducted"
      render template: "admin/users/orders/new", status: :unprocessable_entity
      return
    end

    ActiveRecord::Base.transaction do
      if @order.valid?(:balance_operate) && @order.save
        order_pay
        flash[:notice] = "Coin for #{@order.user.email} deducted!"
        redirect_to admin_root_path
      else
        flash[:alert] = "Coin failed to deduct: #{ @order.errors.full_messages.to_sentence }"
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
      if @order.may_cancel?
        @order.cancel!
      end
      flash[:alert] = "Coin failed to deduct: #{ @order.errors.full_messages.to_sentence }"
      render template: "admin/users/orders/new", status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
  end
end