# frozen_string_literal: true

class V1::Designers::FirstProductSerializer < ActiveModel::Serializer
  attributes :name, :category, :sku, :selling_price, :description, :additional_info

  def category
    object.sub_category.name
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
