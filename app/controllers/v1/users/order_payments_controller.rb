# frozen_string_literal: true

class V1::Users::OrdersController < V1::Users::BaseController
  def create
    op = current_user.order_payments.new(order_payment_params)
    if op.save
      render json: { message: 'Order Payment successfully created' }, status: 201
    else
      render json: { errors: op.errors }, status: 400
    end
  end

  def update
    op = current_user.order_payments.find(params[:id])
    if op.update(op_update_params)
      render json: { message: 'Order Payment successfully updated' }, status: 200
    else
      render json: { errors: op.errors }, status: 400
    end
  end

  private

  def op_create_params
    params.require(:order_payment).permit(:order_id, :price, extra: {})
  end

  def op_update_params
    params.require(:order_payment).permit(:payment_id, :success, extra: {})
  end
end
