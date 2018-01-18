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
      notify_payment_success(op)
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

  def notify_payment_success(op)
   begin
      body = "Your payment was successful for the offer by #{ op.order.designer.full_name } for #{ op.order.offer_quotation.offer.request.name }"
      current_user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: op.order_id)
      send_notification(current_user.devise_token, body, " ")
    rescue
    end 
  end
end
