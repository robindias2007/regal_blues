# frozen_string_literal: true

class RequestImage < ApplicationRecord
  belongs_to :request, optional: true

  validates :serial_number, presence: true
  validates :width, :height, :serial_number, numericality: { only_integer: true }

  before_save :make_image, if: :blank_image?

  mount_base64_uploader :image, ImageUploader

  private

  def make_image
    require 'open3'
    self.image = Open3.popen3("convert -size 1024x1024 canvas:#{color} INLINE:PNG:-") do |_, out, _, _|
      out.read.chomp
    end
  end

  def blank_image?
    image.blank?
  end
end
