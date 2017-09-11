# frozen_string_literal: true

class V1::Users::HomeController < V1::Users::BaseController
  skip_before_action :authenticate

  def mobile
    if current_user.present?
      if current_user.live_orders?
        orders = current_user.orders.order(created_at: :desc).limit(3)
        render json: { orders: order_resource(orders), requests: [], recos: [], top_designers: [] }
      elsif current_user.requests_but_no_orders?
        requests = current_user.requests.includes(:sub_category).order(created_at: :desc).limit(3)
        render json: { requests: request_resource(requests), recos: [], top_designers: [], orders: [] }
      elsif current_user.no_requests_or_orders?
        # TODO: Design a recommendation engine
        recos = Product.includes(designer: :designer_store_info).order('RANDOM()').limit(6)
        render json: { recos: recommendation_resource(recos), top_designers: [], orders: [], requests: [] }
      end
    else
      # TODO: Design an algorithm to quickly calculate the ratings of a designer
      top_designers = Designer.includes(:designer_store_info, :sub_categories).order('RANDOM()').limit(6)
      render json: { top_designers: td_resource(top_designers), recos: [], orders: [], requests: [] }
    end
  end

  private

  def td_resource(top_designers)
    td_options = { each_serializer: V1::Users::TopDesignersSerializer }
    ActiveModelSerializers::SerializableResource.new(top_designers, td_options)
  end

  def request_resource(requests)
    rq_options = { each_serializer: V1::Users::RequestsSerializer }
    ActiveModelSerializers::SerializableResource.new(requests, rq_options)
  end

  def recommendation_resource(recos)
    recc_options = { each_serializer: V1::Users::ProductsSerializer }
    ActiveModelSerializers::SerializableResource.new(recos, recc_options)
  end

  def order_resource(orders)
    order_options = { each_serializer: V1::Users::OrdersSerializer }
    ActiveModelSerializers::SerializableResource.new(orders, order_options)
  end
end
