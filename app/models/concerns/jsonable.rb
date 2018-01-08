module Jsonable
  extend ActiveSupport::Concern

  included do

	  def as_request_json
	    self.requests.collect{|request| {
	      id: request.id,
	      name: request.name,
	      size: request.size,
	      min_budget: request.min_budget,
	      max_budget: request.max_budget,
	      timeline: request.timeline,
	      description: request.description,
	      user_id: request.user_id,
	      sub_category_id: request.sub_category_id,
	      created_at: request.created_at,
	      updated_at: request.updated_at,
	      address_id: request.address_id,
	      status: request.status,
	      origin: request.origin,
	      message_count: msg_count(request),
	      unread_message_count: unread_msg_count(request)
	    }}
	  end

	  def as_order_json
	    self.orders.collect{|order| {
	      id: order.id,
	      designer_id: order.designer_id,
	      user_id: order.user_id,
	      offer_quotation_id: order.offer_quotation_id,
	      status: order.status,
	      order_id: order.order_id,
	      created_at: order.created_at,
	      updated_at: order.updated_at,
	      message_count: msg_count(order),
	      unread_message_count: unread_msg_count(order)
	    }}
	  end

	  private 

	  def msg_count(receiver)
			return self.conversations.where(receiver_id: receiver.id)[0].messages.count rescue 0
	  end

	  def unread_msg_count(receiver)
	  	return self.conversations.where(receiver_id: receiver.id)[0].messages.where(read: false).count rescue 0
	  end
  end
end