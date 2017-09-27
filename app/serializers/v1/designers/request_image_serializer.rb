# frozen_string_literal: true

class V1::Designers::RequestImageSerializer < ActiveModel::Serializer
  attributes :id, :image, :width, :height, :color, :description, :serial_number
end
