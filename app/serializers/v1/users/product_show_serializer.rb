# frozen_string_literal: true

class V1::Users::ProductShowSerializer < ActiveModel::Serializer
  attributes :id, :name, :designer_name, :selling_price, :image, :more_items, :similar_items

  def designer_name
    object&.designer&.designer_store_info&.display_name || 'Generic Store Name'
  end

  def image
    # TODO: Change this to the cover image of the store
    object.designer.avatar || 'Default Image URL'
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
