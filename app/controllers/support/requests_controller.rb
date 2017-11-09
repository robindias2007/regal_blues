# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @data = {
      total_users:     User.count,
      total_designers: Designer.count,
      total_requests:  Request.count,
      total_offers:    OfferQuotation.count,
      total_orders:    Order.count,
      total_products:  Product.count
    }
  end
end
