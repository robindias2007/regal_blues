# frozen_string_literal: true

class V1::Users::SearchProductsSerializer < ActiveModel::Serializer
  attributes :id, :name, :cover

  def cover
    object.images.first&.image || 'Default Image URL'
  end
end
