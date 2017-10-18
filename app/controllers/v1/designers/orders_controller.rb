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
      order.designer_confirm!
      render json: { message: 'Order has been marked as confirmed. User will be notified of the same.' }
    else
      render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    end
  end

  def fabric_unavailable
    order = current_designer.orders.find(params[:id])
    if order.paid? && order.all_options_selected?
      order.fabric_unavailable!
      render json: { message: 'Order has been marked as fabric unavailable. User will be notified of the same.' }
    else
      render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    end
  end

  private

  def first_instance_of(orders)
    ActiveModelSerializers::SerializableResource.new(orders.first,
      serializer: V1::Designers::OrderShowSerializer)
  end
end
