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
      render json: { message: 'Order has been marked as confirmed. User will be notified of the same.' }
    else
      render json: { errors:  order.errors,
                     message: 'Something went wrong. Maybe not all the orders are selected by the user or the order has not been paid yet' }, status: 400
    end
  end

  def fabric_unavailable_data
    order = current_designer.orders.find(params[:id])
    render json: order, serializer: V1::Designers::OrderFabricUnavailableSerializer
  end

  def fabric_unavailable
    order = current_designer.orders.find(params[:id])
    if order.paid? && order.offer_quotation.update!(offer_quotation_params)
      order.fabric_unavailable!
      render json: { message: 'Order has been marked as fabric unavailable and updated with new fabric. \
        User will be notified of the same.' }
    else
      render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def destroy_gallery
    if find_gallery_by(params[:id], params[:gallery_id])&.destroy
      render json: { message: 'Gallery successfully deleted along with its images' }, status: 204
    else
      render json: { message: 'Something went wrong. Could not delete the gallery' }, status: 400
    end
  end

  def destroy_gallery_image
    if find_image_by(params[:id], params[:gallery_id], params[:image_id])&.destroy
      render json: { message: 'Image successfully deleted' }, status: 204
    else
      render json: { message: 'Something went wrong. Could not delete the image' }, status: 400
    end
  end

  private

  def offer_quotation_params
    params.require(:offer_quotation).permit(:fabric_unavailable_note,
      offer_quotation_galleries_attributes: [:id, :name, :_destroy,
                                             images_attributes: %i[id image description _destroy]])
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
