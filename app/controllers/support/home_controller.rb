# frozen_string_literal: true

class Support::HomeController < ApplicationController
  def index
    if support_signed_in?
      @data = {
        total_users:     User.count,
        total_designers: Designer.count,
        total_requests:  Request.count,
        total_offers:    OfferQuotation.count,
        total_orders:    Order.count,
        total_products:  Product.count
      }
    else
      redirect_to '/supports/sign_in'
    end
  end
end
