# frozen_string_literal: true

class V1::Designers::OrdersController < V1::Designers::BaseController
  include PushNotification
  def index
    orders = Order.includes(:user, offer_quotation: [offer: [request: :sub_category]]).where(designer: current_designer)
                  .order(created_at: :desc)
    render json: orders, each_serializer: V1::Designers::OrdersSerializer, meta: first_instance_of(orders)
  end

  def show
    order = current_designer.orders.find(params[:id])
    render json: order, serializer: V1::Designers::OrderShowSerializer
  end

  def confirm
    order = current_designer.orders.find(params[:id])
    if order.paid? && order.all_options_selected?
      order.designer_confirms!
      notify_confirm(order)
      render json: { message: 'Order has been marked as confirmed. User will be notified of the same.' }
    else
      notify_cancel(order)
      render json: {
        errors:  order.errors,
        message: 'Not all the orders are selected by the user or the order has not been paid yet'
      }, status: 400
    end
  end

  def fabric_unavailable_data
    order = current_designer.orders.find(params[:id])
    render json: order , serializer: V1::Designers::OrderFabricUnavailableSerializer
  end

  def fabric_unavailable
    order = current_designer.orders.find(params[:id])
    if order.paid? && order.offer_quotation.update!(fabric_unavailable_params)
      order.fabric_unavailable!
      notify_fabric_unavailable(order)
      render json: { message: 'Order has been marked as fabric unavailable and updated with new fabric. \
        User will be notified of the same.' }
    else
      render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def toggle_active_gallery_image
    if find_image_by(params[:id], params[:gallery_id], params[:image_id])&.safe_toggle!(:disabled)
      render json: { message: 'Image successfully disabled' }, status: 200
    else
      render json: { message: 'Something went wrong. Could not update the image' }, status: 400
    end
  end

  def give_more_options_data
    order = current_designer.orders.find(params[:id])
    NotificationsMailer.more_option(order).deliver_later
    begin
      body = "Awaiting more options on your offer"
      order.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.designer.devise_token, body, body)
    rescue  
    end
    
    render json: order, serializer: V1::Designers::OrderGiveMoreOptionsSerializer
  end

  def give_more_options
    order = current_designer.orders.find(params[:id])
    if order.user_awaiting_more_options? && order.offer_quotation.update(give_more_options_params)
      notify_more_option(order)
      order.designer_gives_more_options!
      render json: order, serializer: V1::Designers::OrderShowSerializer
    else
      render json: { errors: order.errors, message: "Designer can't give more options for this order" }
    end
  end

  private

  def fabric_unavailable_params
    params.require(:offer_quotation).permit(:id, :offer_quotation, :designer_note,
      offer_quotation_galleries_attributes: [:id, :name, images_attributes: %i[id image description disabled new]])
  end

  def give_more_options_params
    params.require(:offer_quotation).permit(:id, :designer_note,
      offer_quotation_galleries_attributes: [:id, :name, images_attributes: %i[image description disabled new]])
  end

  def first_instance_of(orders)
    ActiveModelSerializers::SerializableResource.new(orders.first,
      serializer: V1::Designers::OrderShowSerializer)
  end

  def find_gallery_by(order_id, gallery_id)
    current_designer.orders.find(order_id).offer_quotation.offer_quotation_galleries.find(gallery_id)
  end

  def find_image_by(order_id, gallery_id, image_id)
    find_gallery_for(order_id, gallery_id).find(image_id)
  end

  def notify_confirm(order)
    begin
      NotificationsMailer.order_confirm(order).deliver_later
      body = "Your order with order id #{order.order_id} has been accepted by #{order.designer.full_name}."
      order.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.user.devise_token, body, body)
    rescue
    end
  end

  def notify_cancel(order)
    begin
      body_u = "Your Order with id<%= order.order_id %> has been cancelled. Money would be refunded in 7 working days."
      body_d = "Your Order with id <%= order.order_id %> has been cancelled by <%= order.user.full_name%>"
      NotificationsMailer.order_cancel(order.user, order).deliver_later
      NotificationsMailer.order_cancel(order.designer, order).deliver_later
      order.user.notifications.create(body: body_u, notificationable_type: "Order", notificationable_id: order.id)
      order.designer.notifications.create(body: body_d, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.user.devise_token, "Order Cancelled", body_u)
      send_notification(order.designer.devise_token, "Order Cancelled", body_d)
    rescue
    end 
  end

  def notify_fabric_unavailable(order)
    begin
      body = "<%= order.designer.full_name %> ran out of the fabric you selected for Order <%= order.order_id %>. Please select one from the existing."
      NotificationsMailer.fabric_unavailable(order).deliver_later
      order.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.user.devise_token, body, body)
    rescue
    end
  end

  def notify_more_option(order)
    begin
      alert = "Awaiting more options on your offer"
      body = "Your offer for <%= order.offer_quotation.offer.request.name%> has been accepted by <%= order.user.full_name %>. <%= order.user.full_name %> has asked for more option. Send more options"
      NotificationsMailer.more_option(order).deliver_later
      order.designer.notifications.create(body: body, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.designer.devise_token, alert, body)
    rescue
    end
  end
end
