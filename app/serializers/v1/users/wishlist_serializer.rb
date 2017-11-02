# frozen_string_literal: true

class V1::Users::WishlistSerializer < ActiveModel::Serializer
  attributes :id, :name, :designer_name, :selling_price, :image

  def designer_name
    object&.designer&.designer_store_info&.display_name || 'Generic Store Name'
  end

  def image
    # TODO: Change this to the cover image of the store
    # object.designer.avatar || 'Default Image URL'
    object.images.order(created_at: :desc).first.image.url || 'Default Image URL'
  end
end
