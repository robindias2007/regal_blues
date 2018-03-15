# frozen_string_literal: true

class OfferQuotation < ApplicationRecord
  MAX_MEASUREMENT = 1

  belongs_to :offer

  has_many :offer_quotation_galleries, dependent: :destroy
  has_many :offer_measurements, dependent: :destroy

  has_one :order, dependent: :destroy

  validates :price, :description, presence: true
  validates :description, length: { in: 4..960 }
  validates :price, numericality: true
  validate  :max_one_measurement

  validates :price, numericality: { greater_than: 4000 }

  accepts_nested_attributes_for :offer_quotation_galleries, allow_destroy: true
  accepts_nested_attributes_for :offer_measurements

  private

  def max_one_measurement
    errors.add(:offer_measurements, "More than #{MAX_MEASUREMENT} measurement can't be accepted") if
      offer_measurements.size > 1
  end
end
