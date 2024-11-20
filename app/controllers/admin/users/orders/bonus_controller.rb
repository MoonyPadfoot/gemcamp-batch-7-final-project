class Admin::Users::Orders::BonusController < AdminsController
  def new
    @user = User.find(params[:client_id])
    @order = Order.new
    render template: "admin/users/orders/new"
  end

  def create
    @order = Order.new(params.require(:order).permit(:coin, :genre, :remarks))
    @order.user = User.find(params[:client_id])

    ActiveRecord::Base.transaction do
      if @order.valid?(:balance_operate) && @order.save
        order_pay
        order_submit
        flash[:notice] = "Bonus for #{@order.user.email} added!"
        redirect_to admin_root_path
      else
        flash[:alert] = "Bonus failed to add: #{ @order.errors.full_messages.to_sentence }"
        render template: "admin/users/orders/new", status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def order_submit
    if @order.may_submit?
      @order.submit!
    else
      flash[:alert] = "Bonus failed to add: #{ @order.errors.full_messages.to_sentence }"
      render template: "admin/users/orders/new", status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
  end

  def order_pay
    if @order.may_pay?
      @order.pay!
    else
      flash[:alert] = "Bonus failed to add: #{ @order.errors.full_messages.to_sentence }"
      render template: "admin/users/orders/new", status: :unprocessable_entity
      raise ActiveRecord::Rollback
    end
  end
end