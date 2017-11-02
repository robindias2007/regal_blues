# frozen_string_literal: true

class V1::Users::FavoritesSerializer < ActiveModel::Serializer
  attributes :id, :designer_name, :min_price, :image

  def designer_name
    object.designer_store_info&.display_name || 'Default Store Name'
  end

  def image
    object.avatar
  end

  def min_price
    object.designer_store_info&.min_order_price&.round || 0.0
  end
end
