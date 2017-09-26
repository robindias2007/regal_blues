# frozen_string_literal: true

class RequestImage < ApplicationRecord
  belongs_to :request

  validates :width, :height, :image, :description, presence: true
  validates :width, :height, numericality: { only_integer: true }

  before_validation :make_image, if: :blank_image?

  mount_base64_uploader :image, ImageUploader

  private

  def make_image
    self.image = `convert -size 1024x1024 canvas:${self.color} INLINE:PNG:-`
  end

  def blank_image?
    image.blank?
  end
end
