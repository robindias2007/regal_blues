# frozen_string_literal: true

class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :selling_price, :active

  has_many :images
  belongs_to :sub_category
  has_one :product_info

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :image, :width, :height
  end

  class SubCategorySerializer < ActiveModel::Serializer
    attributes :id, :name
  end

  class ProductInfoSerializer < ActiveModel::Serializer
    attributes :id, :color, :fabric, :care, :work
  end
end
