# frozen_string_literal: true

class V1::Designers::ProductIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :selling_price, :active, :sku, :image, :category

  def image
    object.images.order(created_at: :asc).first&.image || 'Default Image URL'
  end

  def category
    object.sub_category.name
  end
end
