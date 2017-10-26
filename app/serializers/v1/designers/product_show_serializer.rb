# frozen_string_literal: true

class V1::Designers::ProductShowSerializer < ActiveModel::Serializer
  attributes :name, :category, :sku, :selling_price, :description, :additional_info, :images

  def category
    object.sub_category.name
  end

  def images
    object.images.order(created_at: :asc).map { |image| ImageSerializer.new(image) }
  end

  def additional_info
    {
      fabric: object.product_info.fabric,
      care:   object.product_info.care,
      notes:  object.product_info.notes,
      work:   object.product_info.work
    }
  end
end
