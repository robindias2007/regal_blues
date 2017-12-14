# frozen_string_literal: true

class RequestImage < ApplicationRecord
  belongs_to :request, optional: true

  validates :serial_number, presence: true
  validates :width, :height, :serial_number, numericality: { only_integer: true }

  #before_save :make_image, if: :blank_image?

  mount_base64_uploader :image, ImageUploader

  private

  def make_image
    require 'open3'
    image_data = Open3.popen3("convert -size 1024x1024 canvas:#{color} PNG:-| base64") do |_, out, _, _|
      out.read.chomp
    end
    self.image = 'data:image/png;base64,' + image_data
  end

  def blank_image?
    image.blank?
  end
end
