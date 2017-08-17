# frozen_string_literal: true

class ProductImage < ApplicationRecord
  belongs_to :product
  has_one :image, as: :imageable
end
