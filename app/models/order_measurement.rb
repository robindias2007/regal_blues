# frozen_string_literal: true

class OrderMeasurement < ApplicationRecord
  belongs_to :order

  validates :data, presence: true
  validate :validate_key
  validate :validate_tag_size
  validate :validate_tags

  private

  def validate_tags
    errors.add(:data, 'key for the hash is not valid') if
      order.offer_quotation.offer_measurements.first.data.fetch('tags') != data.fetch('measurements').keys
  end

  def validate_tag_size
    errors.add(:data, 'not all measurements are present') if
      order.offer_quotation.offer_measurements.first.data.fetch('tags').size != data.fetch('measurements').keys.size
  end

  def validate_key
    errors.add(:data, 'key for the hash is not valid') if data.keys.first != 'measurements'
  end
end
