# frozen_string_literal: true

class V1::Users::HomeController < V1::Users::BaseController
  skip_before_action :authenticate, only: :mobile

  def mobile
    if current_user.present?
      render_orders_requests
    else
      orders_or_requests_or_recommendations
    # else
    #   render_top_designers
    end
  end

  private

  def orders_or_requests_or_recommendations
    if current_user.live_orders?
      render_orders
      # render json: { message: 'Not implemented' }, status: 501
    elsif current_user.requests_but_no_orders?
      render_requests
    elsif current_user.no_requests_or_orders?
      render_recos
    end
  end

  def render_orders_requests
    orders = current_user.orders.order(created_at: :desc).limit(3)
    requests = current_user.requests.order(created_at: :desc).limit(3)
    ord_req = (orders + requests).sort {|x,y| y[:created_at]<=>x[:created_at]}
    if ord_req.first.name.present?
      requests = current_user.requests.order(created_at: :desc).limit(3)
      render json: { requests: request_resource(requests), recos: [], top_designers: [], orders: [] }
    else
      orders = current_user.orders.order(created_at: :desc).limit(3)
      render json: { orders: order_resource(orders), requests: [], recos: [], top_designers: [] }
    end
  end

  def render_orders
    orders = current_user.orders.order(created_at: :desc).limit(3)
    render json: { orders: order_resource(orders), requests: [], recos: [], top_designers: [] }
  end


  def render_requests
    requests = current_user.requests.order(created_at: :desc).limit(3)
    render json: { requests: request_resource(requests), recos: [], top_designers: [], orders: [] }
  end

  def render_recos
    # TODO: Design a recommendation engine
    recos = Product.includes(designer: :designer_store_info).order('RANDOM()').limit(6)
    render json: { recos: recommendation_resource(recos), top_designers: [], orders: [], requests: [] }
  end

  def render_top_designers
    # TODO: Design an algorithm to quickly calculate the ratings of a designer
    top_designers = Designer.includes(:designer_store_info, :sub_categories).order('RANDOM()').limit(6)
    render json: { top_designers: td_resource(top_designers), recos: [], orders: [], requests: [] }
  end

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
