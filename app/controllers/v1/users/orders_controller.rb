# frozen_string_literal: true

class V1::Users::OrdersController < V1::Users::BaseController
  def index
    orders = Order.includes(:user, offer_quotation: [offer: [request: :sub_category]]).where(user: current_user)
                  .order(created_at: :desc)
    render json: orders, each_serializer: V1::Users::OrdersSerializer, meta: first_instance_of(orders)
  end

  def show
    order = current_user.orders.find(params[:id])
    render json: order, serializer: V1::Users::OrderShowSerializer
  end

  private

  def first_instance_of(orders)
    ActiveModelSerializers::SerializableResource.new(orders.first,
      serializer: V1::Users::OrderShowSerializer)
  end
end
