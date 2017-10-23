# frozen_string_literal: true

class OfferQuotation < ApplicationRecord
  MAX_MEASUREMENT = 1

  belongs_to :offer

  has_many :offer_quotation_galleries, dependent: :destroy
  has_many :offer_measurements, dependent: :destroy

  validates :price, :description, presence: true
  validates :description, length: { in: 4..480 }
  validates :price, numericality: true
  validate  :max_one_measurement

  accepts_nested_attributes_for :offer_quotation_galleries, allow_destroy: true
  accepts_nested_attributes_for :offer_measurements

  private

  def max_one_measurement
    errors.add(:offer_measurements, "More than #{MAX_MEASUREMENT} measurement can't be accepted") if
      offer_measurements.size > 1
  end
end
