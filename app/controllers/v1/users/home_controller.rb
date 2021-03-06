# frozen_string_literal: true
  
class V1::Users::HomeController < V1::Users::BaseController
  skip_before_action :authenticate, only: %i[mobile mobile_v2]

  def mobile
    if current_user.present?
      #render_orders_requests
    # else
    orders_or_requests_or_recommendations
    else
      render_top_designers
    end
  end

  def mobile_v2
    if current_user.present?
      if current_user.orders_requests_present?
        render_orders_requests_v2
      elsif current_user.no_requests_or_orders?
        render_recos_v2
      end
    else
      render_external_search_v2
    end
  end

  private

  def orders_or_requests_or_recommendations
    # if current_user.live_orders?
    #   render_orders
    #   # render json: { message: 'Not implemented' }, status: 501
    # elsif current_user.requests_but_no_orders?
    #   render_requests
    # elsif current_user.no_requests_or_orders?
    #   render_recos
    # end
    if current_user.orders_requests_present?
      render_orders_requests
    elsif current_user.no_requests_or_orders?
      render_recos
    end
  end

  def render_orders_requests
    order_name_array = Array.new     
    request_name_array = Array.new
    new_requests = Array.new

    orders = current_user.orders.order(created_at: :desc).limit(3).each do |f|
      order_name_array.push(f.offer_quotation.offer.request.name)
    end

    requests = current_user.requests.order(updated_at: :desc).each do |f|
      request_name_array.push(f.name)
    end
    
    (request_name_array - order_name_array).each do |f|
      new_requests.push(Request.where(name:f))
    end

    #Combination of Order and Requests which is not an order and sorting based on created_at 
    ord_req = (orders + new_requests.flatten.sort {|x,y| y[:created_at]<=>x[:created_at]}.first(3)).sort {|x,y| y[:created_at]<=>x[:created_at]}.first(3)
    
    if (ord_req.first.name.present? rescue nil)
      req1 = ord_req.first rescue nil 
    end
    if (ord_req.second.name.present? rescue nil)
      req2 = ord_req.second rescue nil
    end
    if (ord_req.third.name.present? rescue nil)
      req3 = ord_req.third rescue nil
    end

    if (ord_req.first.designer_id.present? rescue nil)
      ord1 = ord_req.first rescue nil 
    end
    if (ord_req.second.designer_id.present? rescue nil)
      ord2 = ord_req.second rescue nil
    end
    if (ord_req.third.designer_id.present? rescue nil)
      ord3 = ord_req.third rescue nil
    end

    #Pushing each req into an array
    request_array = Array.new
    request_array.push(req1)
    request_array.push(req2)
    request_array.push(req3)

    #Pushing each order into an array
    order_array = Array.new
    order_array.push(ord1)
    order_array.push(ord2)
    order_array.push(ord3)

    #Removing the null values from an array
    requests_json_array = request_array.compact
    orders_json_array = order_array.compact
    

    picks = Pick.where(cat_name:nil)
    support_id = Support.first.common_id
    if current_user.requests.present?
      a = ConfigVariable.where(event_name:"home_custom_search")
      a.first.param2 = nil
      array = Array.new
      array.push(a.first)

      configurations = array + ConfigVariable.where.not(event_name:"home_custom_search") 
    else
      configurations = ConfigVariable.all
    end
    configurations_all = ConfigVariable.all
    # request_offers = current_user.requests.includes(:offers).where.not( :offers => { :request_id => nil } ).order(updated_at: :desc)
    # all_req = current_user.requests.order(updated_at: :desc)
    # rest_requests = (all_req - request_offers).to_a
    # requests = request_offers + rest_requests
    # ord = Order.includes(:user, offer_quotation: [offer: [request: :sub_category]]).where(user: current_user)
    # orders = ord.where(status:["designer_confirmed","designer_gave_more_options"]).order(updated_at: :desc)
    # rest_orders = ord.where.not(status:["designer_confirmed","designer_gave_more_options"]).order(updated_at: :desc)

    # render json: { requests: request_resource(request_offers), orders:order_resource(orders), rest_orders: order_resource(rest_orders) ,  rest_requests: request_resource(rest_requests)  ,recos: [], user: current_user, explore:picks}
     render json: { 
      requests: request_resource(requests_json_array), 
      orders:order_resource(orders_json_array),
      recos: [],
      user: profile_serializer(current_user), 
      support: support_id,
      configurations: configurations,
      configurations_all: configurations_all, 
      explore: picks
    }
  end

  def render_orders_requests_v2
    requests = current_user.requests.order(updated_at: :desc).limit(3)
    orders = current_user.orders.order(updated_at: :desc).limit(3)
    support_id = Support.first.common_id
    configurations = ConfigVariable.all
    sub_categories = SubCategory.order(serial_no: :asc).pluck(:name)
    search_suggestions = SearchSuggestion.order(serial_no: :asc).pluck(:name)
    
    render json: { 
      requests: request_resource(requests), 
      orders:order_resource(orders),
      user: profile_serializer(current_user), 
      sub_categories: sub_categories,
      support: support_id,
      configurations: configurations,
      search_suggestions: search_suggestions
    }
  end

  def render_orders
    orders = current_user.orders.order(created_at: :desc).limit(3)
    support_id = Support.first.common_id
    render json: { orders: order_resource(orders), requests: [], recos: [], top_designers: [], support: support_id }
  end


  def render_requests
    requests = current_user.requests.order(created_at: :desc).limit(3)
    support_id = Support.first.common_id
    render json: { requests: request_resource(requests), recos: [], top_designers: [], orders: [], support: support_id }
  end

  def render_recos
    # TODO: Design a recommendation engine
    recos = Product.includes(designer: :designer_store_info).order('RANDOM()').limit(6)
    picks = Pick.where(cat_name:"Lehenga")
    support_id = Support.first.common_id
    configurations = ConfigVariable.all
    configurations_all = ConfigVariable.all
    render json: { recos: recommendation_resource(recos), top_designers: [], orders: [], requests: [] ,explore: picks , user: profile_serializer(current_user), support: support_id, configurations: configurations, configurations_all: configurations_all}
  end

  def render_recos_v2
    # TODO: Design a recommendation engine
    recos = Product.includes(designer: :designer_store_info).order('RANDOM()').limit(6)
    support_id = Support.first.common_id
    configurations = ConfigVariable.all
    sub_categories = SubCategory.order(serial_no: :asc).pluck(:name)
    search_suggestions = SearchSuggestion.order(serial_no: :asc).pluck(:name)
    render json: 
    { recos: recommendation_resource(recos), 
      orders: [], 
      requests: [], 
      user: profile_serializer(current_user), 
      sub_categories: sub_categories,
      support: support_id, 
      configurations: configurations,
      search_suggestions: search_suggestions
    }
  end

  def render_top_designers
    # TODO: Design an algorithm to quickly calculate the ratings of a designer
    top_designers = Designer.includes(:designer_store_info, :sub_categories).order('RANDOM()').limit(6)
    picks = Pick.where(cat_name:"Lehenga")
    support_id = Support.first.common_id
    configurations = ConfigVariable.all
    configurations_all = ConfigVariable.all
    render json: { top_designers: td_resource(top_designers), recos: [], orders: [], requests: [], explore: picks, support: support_id ,configurations: configurations, configurations_all: configurations_all}
  end

  def render_external_search_v2
    support_id = Support.first.common_id
    configurations = ConfigVariable.all
    sub_categories = SubCategory.order(serial_no: :asc).pluck(:name)
    search_suggestions = SearchSuggestion.order(serial_no: :asc).pluck(:name)
    render json: { 
      support: support_id,
      configurations: configurations,
      sub_categories: sub_categories,
      search_suggestions: search_suggestions
    }
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

  private
  
  def profile_serializer(current_user)
    ActiveModelSerializers::SerializableResource.new(current_user,
      each_serializer: V1::Users::ProfileSerializer)
  end

  def config_serializer(configurations)
    ActiveModelSerializers::SerializableResource.new(configurations,
      each_serializer: V1::Users::ConfigVariableSerializer)
  end
end
