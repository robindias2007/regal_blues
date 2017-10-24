# frozen_string_literal: true

class V1::Designers::OrdersController < V1::Designers::BaseController
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
      # TODO: Notify the user
      render json: { message: 'Order has been marked as confirmed. User will be notified of the same.' }
    else
      render json: {
        errors:  order.errors,
        message: 'Not all the orders are selected by the user or the order has not been paid yet'
      }, status: 400
    end
  end

  def fabric_unavailable_data
    order = current_designer.orders.find(params[:id])
    render json: order, serializer: V1::Designers::OrderFabricUnavailableSerializer
  end

  def fabric_unavailable
    order = current_designer.orders.find(params[:id])
    if order.paid? && order.offer_quotation.update!(fabric_unavailable_params)
      order.fabric_unavailable!
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
    galleries = OfferQuotationGallery.joins(:order_option)
                                     .where(order_options: {
                                       order: order, more_options: true, image_id: nil
                                       })
    render json: galleries, each_serializer: V1::Designers::OfferQuotationGallerySerializer
  end

  def give_more_options
    order = current_designer.orders.find(params[:id])
    if order.user_awaiting_more_options? && order.offer_quotation.update(give_more_options_params)
      order.designer_gave_more_options!
      render json: { message: 'Order has been marked as designer gave more options.' }
    else
      render json: { errors: order.errors, message: "Designer can't give more options for this order" }
    end
  end

  private

  def fabric_unavailable_params
    params.require(:offer_quotation).permit(:designer_note,
      offer_quotation_galleries_attributes: [:name, images_attributes: %i[image description disabled]])
  end

  def give_more_options_params
    params.require(:offer_quotation).permit(:designer_note,
      offer_quotation_galleries_attributes: [:name, images_attributes: %i[image description disabled]])
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
end