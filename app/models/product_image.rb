# frozen_string_literal: true

class ProductImage < ApplicationRecord
  belongs_to :product
  has_many :images, as: :imageable
end
