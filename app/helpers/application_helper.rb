# frozen_string_literal: true

module ApplicationHelper
  def time_to_deliver(order)
    timeline = order.offer_quotation.offer.request.timeline
    distance_of_time_in_words(order.created_at, order.created_at + timeline.weeks)
  end
end
