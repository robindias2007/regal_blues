# frozen_string_literal: true

class V1::Users::ProfileSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :email, :mobile_number, :bio, :membership_start_date, :redeem ,:location, :wishlist, :favorite_designers, :order_count, :request_count,
    :avatar, :username, :gender, :verified, :confirmed

  def order_count
    object.orders.paid.count
  end

  def request_count
    object.requests.count
  end

  def location
    object&.addresses&.first&.country
  end

  def wishlist
    object.products.map do |product|
      ActiveModelSerializers::SerializableResource.new(product,
        serializer: V1::Users::ProductsSerializer).as_json
    end
  end

  def favorite_designers
    object.designers.map do |designer|
      ActiveModelSerializers::SerializableResource.new(designer,
        serializer: V1::Users::FavoritesSerializer).as_json
    end
  end

  def confirmed
    true
  end
end
