# frozen_string_literal: true

class V1::Designers::ProductIndexSerializer < ActiveModel::Serializer
  attributes :id, :name, :selling_price, :active

  has_many :images
  belongs_to :sub_category

  class ImageSerializer < ActiveModel::Serializer
    attributes :id, :image, :width, :height
  end

  class SubCategorySerializer < ActiveModel::Serializer
    attributes :id, :name
  end
end
