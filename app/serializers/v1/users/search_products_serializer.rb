# frozen_string_literal: true

class V1::Users::SearchProductsSerializer < ActiveModel::Serializer
  attributes :id, :name, :cover

  def cover
    object.images.order(created_at: :desc).first&.image || 'Default Image URL'
  end
end
