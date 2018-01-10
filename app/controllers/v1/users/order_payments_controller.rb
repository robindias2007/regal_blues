# frozen_string_literal: true

class V1::Users::OrderPaymentsController < V1::Users::BaseController
  include PushNotification
  def create
    op = current_user.order_payments.new(op_create_params)
    if op.save
      NotificationsMailer.payment(current_user, op).deliver_later
      render json: { message: 'Order Payment successfully created', op_id: op.id }, status: 201
    else
      render json: { errors: op.errors }, status: 400
    end
  end

  def update
    op = current_user.order_payments.find(params[:id])
    if op.update(op_update_params)
      begin
        body = "Payment Successful"
        current_user.notifications.create(body: body, notification_type: "order")
        send_notification(current_user.devise_token, body, body)
      rescue
      end
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
