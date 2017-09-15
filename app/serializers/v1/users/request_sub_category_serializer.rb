# frozen_string_literal: true

class V1::Users::RequestSubCategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :image
end
