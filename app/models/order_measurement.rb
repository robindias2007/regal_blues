# frozen_string_literal: true

class OrderMeasurement < ApplicationRecord
  belongs_to :order
  
  validates :data, presence: true
  validate :validate_key
  validate :validate_tag_size
  validate :validate_tags

  mount_base64_uploader :image, ImageUploader

  before_save :capitalize_data

  private

  def validate_tags
    errors.add(:data, 'key for the hash is not valid#tags_measurement') if
      order.offer_quotation.offer_measurements.first.data.fetch('tags').map(&:titlecase).sort != data.fetch('measurements').keys.map(&:titlecase).sort
  end

  def validate_tag_size
    errors.add(:data, 'not all measurements are present') if
      order.offer_quotation.offer_measurements.first.data.fetch('tags').size != data.fetch('measurements').keys.size
  end

  def validate_key
    errors.add(:data, 'key for the hash is not valid#measurement') if data.keys.first != 'measurements'
  end

  def capitalize_data
    data.fetch('measurements').keys.each(&:titleize)
  end
end

