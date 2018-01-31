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
      # notify_cancel(order)
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
      order.notify_fu
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
      send_notification(order.designer.devise_token, body, "", extra_data(order))
    rescue  
    end
    
    render json: order, serializer: V1::Designers::OrderGiveMoreOptionsSerializer
  end

  def give_more_options
    order = current_designer.orders.find(params[:id])
    if order.user_awaiting_more_options? && order.offer_quotation.update(give_more_options_params)
      order.delay(run_at: 24.hours.from_now).notify_designer_gave_new_options
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
      body = "Your order with order id #{order.order_id} has been accepted by #{order.designer.full_name}, please give your measurements immediately for designer to start work on your order."
      order.user.notifications.create(body: body, notificationable_type: "Order", notificationable_id: order.id)
      send_notification(order.user.devise_token, body, "", extra_data(order))
    rescue
    end
  end

  def extra_data(order)
    return {type: "Order", id: order.id} rescue ""
  end
end
