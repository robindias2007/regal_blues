# frozen_string_literal: true

class Image < ApplicationRecord
  belongs_to :imageable, polymorphic: true, autosave: true, dependent: :destroy, optional: true
  has_many :order_options, dependent: :destroy

  validates :width, :height, :image, presence: true
  validates :width, :height, numericality: { only_integer: true }

  accepts_nested_attributes_for :imageable

  mount_base64_uploader :image, ImageUploader
end
