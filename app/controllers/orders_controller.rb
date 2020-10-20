class OrdersController < ApplicationController
  def new
    @order = Order.new(product: Product.find(params[:product_id]))
  end

  def create
    if order_params[:is_gift]
      @child = Child.find_by(full_name: child_params[:full_name], birthdate: child_params[:birthdate], parent_name: child_params[:parent_name])
    else
      @child = Child.find_or_create_by(child_params)
    end

    @order = Order.create(order_params.merge(child: @child, user_facing_id: SecureRandom.uuid[0..7]))
    if @order.valid?
      Purchaser.new.purchase(@order, credit_card_params)
      redirect_to order_path(@order)
    else
      render :new
    end
  end

  def show
    @order = Order.find_by(id: params[:id]) || Order.find_by(user_facing_id: params[:id])
  end

private

  def order_params
    params.require(:order).permit(:shipping_name, :product_id, :zipcode, :address, :is_gift, :gift_message).merge(paid: false)
  end

  def child_params
    {
      full_name: params.require(:order)[:child_full_name],
      parent_name: params.require(:order)[:shipping_name],
      birthdate: Date.parse(params.require(:order)[:child_birthdate]),
    }
  end

  def credit_card_params
    params.require(:order).permit( :credit_card_number, :expiration_month, :expiration_year)
  end
end
