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

  def create
    order = current_user.orders.new(order_params)
    order.designer = order.offer_quotation.offer.designer
    if order.save
      # render json: { message: 'Order has been created, now redirecting you to the payment gateway' }
      pay_with_create(order)
    else
      render json: { errors: order.errors }
    end
  end

  def pay
    order = current_user.orders.find(params[:id])
    # payment = PaymentGateway.pay(params[:gateway], order)
    if payment.successfull?
      order.pay!
      render json: { message: 'Payment has been successfull' }
    else
      render json: { errors: order.errors, message: 'Something went wrong' }, status: 400
    end
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
      render json: { message: 'Measurements have been saved' }, status: 201
    else
      render json: { errors: om.errors, message: 'Something went wrong' }, status: 400
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

  def pay_with_create(order)
    # payment = PaymentGateway.pay(params[:gateway], order)
    # if payment.successfull?
    order.pay!
    render json: { message: 'Order has been created and payment has been successfull' }
    # else
    #   render json: { errors: ['Order has been saved but payment could not be completed'] }, status: 400
    # end
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
end
