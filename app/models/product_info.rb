# frozen_string_literal: true

class ProductInfo < ApplicationRecord
  belongs_to :product, autosave: true

  validates :color, :fabric, :care, presence: true
  validates :fabric, :care, length: { in: 3..160 }
end
