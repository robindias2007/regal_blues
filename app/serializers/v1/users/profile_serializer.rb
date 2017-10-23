# frozen_string_literal: true

class V1::Users::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :bio, :location, :wishlist, :favorite_designers, :order_count, :request_count,
    :avatar

  def order_count
    object.orders.paid.count
  end

  def request_count
    object.requests.count
  end

  def location
    object.addresses.first.country
  end

  def wishlist
    'not implemented'
  end

  def favorite_designers
    'not implemented'
  end
end
