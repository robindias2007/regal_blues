# frozen_string_literal: true

class V1::Users::OrdersController < V1::Users::BaseController
  include PushNotification

  def index
    orders = Order.includes(:user, offer_quotation: [offer: [request: :sub_category]]).where(user: current_user)
                  .order(updated_at: :desc)
    render json: orders, each_serializer: V1::Users::OrdersSerializer,
      meta: first_instance_of(orders.order(created_at: :desc))
  end

  def show
    order = current_user.orders.find(params[:id])
    render json: order, serializer: V1::Users::OrderShowSerializer
  end

  def create
    order = current_user.orders.new(order_params)
    order.designer = order.offer_quotation.offer.designer
    if order.save
      pay_and_assign_status(order)
    else
      render json: { errors: order.errors }
    end
  end

  def pay
    # TODO: Implement after integrating payment gateway
    render status: 501
    # order = current_user.orders.find(params[:id])
    # # payment = PaymentGateway.pay(params[:gateway], order)
    # if payment.successfull?
    #   order.pay!
    #   render json: { message: 'Payment has been successfull' }
    # else
    #   render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    # end
  end

  def measurement_tags
    order = current_user.orders.find(params[:id])
    measurement_tags = order.offer_quotation.offer_measurements.first.data
    render json: measurement_tags
  end

  def update_measurements
    order = current_user.orders.find(params[:id])
    return invalid_key_error unless valid_key?
    om = order.build_order_measurement(measurement_params)
    if om.save
      order.give_measurements!
      render json: { message: 'Measurements have been saved' }, status: 201
    else
      render json: { errors: om.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def submit_options
    order = current_user.orders.find(params[:order][:order_id])
    return bad_order unless order.designer_gave_more_options? || order.designer_selected_fabric_unavailable?
    return bad_selection if more_options_present?
    NotificationsMailer.more_option(order).deliver_later if more_options_present?
    if order.update(submit_options_params)
      order.user_selects_options!
      render json: { message: 'Options have been updated' }, status: 201
    else
      render json: { errors: om.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def cancel_order
    order = Order.find(params[:id])
    if order.may_user_cancels_the_order?
      # PaymentGateway.cancel(order)
      order.user_cancels_the_order!
      notify_cancel(order)
      render json: { message: 'Your order has been cancelled. We will process the refund soon' }, status: 200
    else
      render json: { errors: 'You cannot cancel the order at this stage', state: order.status }, status: 400
    end
  end

  private

  def first_instance_of(orders)
    ActiveModelSerializers::SerializableResource.new(orders.first,
      serializer: V1::Users::OrderShowSerializer)
  end

  def order_params
    params.require(:order).permit(:offer_quotation_id,
      order_options_attributes: %i[offer_quotation_gallery_id image_id more_options designer_pick])
  end

  def submit_options_params
    params.require(:order).permit(order_options_attributes: %i[offer_quotation_gallery_id image_id designer_pick])
  end

  def pay_with_create(order)
    # payment = PaymentGateway.pay(params[:gateway], order)
    # if payment.successfull?
    order.pay!
    render json: { message: 'Order has been created successfully', order_id: order.id }
    # else
    #   render json: { errors: ['Order has been saved but payment could not be completed'] }, status: 400
    # end
  end

  def pay_and_assign_status(order)
    pay_with_create(order)
    order.user_asks_more_options! if order.order_options.where.not(more_options: false).any?
  end

  def measurement_params
    params.permit(data: {})
  end

  def valid_key?
    measurement_params.fetch('data').key?('measurements')
  end

  def invalid_key_error
    render json: { errors: 'key for data is not valid' }, status: 400
  end

  def bad_order
    render json: { errors: 'Not a valid order for this selection' }, status: 400
  end

  def more_options_present?
    params[:order][:order_options_attributes].any? { |oo| oo[:more_options] == true }
  end

  def notify_cancel(order)
    begin
      body_u = "Your Order with id #{order.order_id} has been cancelled. Money would be refunded in 7 working days."
      body_d = "Your Order with id #{order.order_id} has been cancelled by #{ order.user.full_name }"
      NotificationsMailer.order_cancel(order.user, order).deliver_later
      NotificationsMailer.order_cancel(order.designer, order).deliver_later
      order.user.notifications.create(body: body_u, notificationable_type: "Order", notificationable_id: order.id)
      order.designer.notifications.create(body: body_d, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.user.devise_token, "Order Cancelled", body_u)
      send_notification(order.designer.devise_token, "Order Cancelled", body_d)
    rescue
    end 
  end
end
