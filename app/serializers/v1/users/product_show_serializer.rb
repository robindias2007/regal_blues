# frozen_string_literal: true

class V1::Users::ProductShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :designer_name, :selling_price, :designer_avatar, :more_items, :similar_items, :description,
    :additional_info, :images

  def designer_name
    object&.designer&.designer_store_info&.display_name || 'Generic Store Name'
  end

  def designer_avatar
    # TODO: Change this to the cover image of the store
    object.designer.avatar || 'Default Image URL'
  end

  def images
    object.images.map do |image|
      ActiveModelSerializers::SerializableResource.new(image,
        serializer: ImageSerializer).as_json
    end
  end

  def additional_info
    {
      fabric: object.product_info.fabric,
      care:   object.product_info.care,
      notes:  object.product_info.notes,
      work:   object.product_info.work
    }
  end

  def more_items
    products = Product.where(designer: object.designer).where.not(id: object.id).order('RANDOM()').limit(6)
    map_serialized(products)
  end

  def similar_items
    products = Product.where(sub_category: object.sub_category).where.not(id: object.id).order('RANDOM()').limit(6)
    map_serialized(products)
  end

  private

  def map_serialized(products)
    products.map do |product|
      ActiveModelSerializers::SerializableResource.new(product,
        serializer: V1::Users::ProductsSerializer).as_json
    end
  end
end
