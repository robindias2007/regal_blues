# frozen_string_literal: true

class ImageSerializer < ActiveModel::Serializer
  attributes :id, :image, :width, :height
end