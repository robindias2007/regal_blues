# frozen_string_literal: true

class V1::Users::ProductsSerializer < ActiveModel::Serializer
  attributes :id, :name, :designer_name, :selling_price, :image, :sub_category

  def designer_name
    object&.designer&.designer_store_info&.display_name || 'Generic Store Name'
  end

  def image
    # TODO: Change this to the cover image of the store
    # object.designer.avatar || 'Default Image URL'
    object.images.first.image.url || 'Default Image URL'
  end

  def sub_category
    object.sub_category.name
  end
end
