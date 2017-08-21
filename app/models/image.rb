# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true, autosave: true, dependent: :destroy, optional: true

  validates :width, :height, :image, presence: true
  validates :width, :height, numericality: { only_integer: true }

  accepts_nested_attributes_for :imageable
end
