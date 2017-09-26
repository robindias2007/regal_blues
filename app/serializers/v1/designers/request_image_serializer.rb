# frozen_string_literal: true

class V1::Designers::ImageSerializer < ActiveModel::Serializer
  attributes :id, :image, :width, :height, :color, :description
end
