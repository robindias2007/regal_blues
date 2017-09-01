# frozen_string_literal: true

class Offer < ApplicationRecord
  MAX_QUOTES = 3
  MAX_MEASUREMENT = 1

  belongs_to :designer
  belongs_to :request

  has_many :offer_measurements
  has_many :offer_quotations

  validates :designer_id, uniqueness: { scope: :request_id }
  validates :designer_id, :request_id, presence: true
  validate :max_number_of_quotations, :max_one_measurement

  accepts_nested_attributes_for :offer_quotations
  accepts_nested_attributes_for :offer_measurements

  private

  def max_number_of_quotations
    errors.add(:offer_quotations, "More than #{MAX_QUOTES} quotations can't be accepted") if
      offer_quotations.size > MAX_QUOTES
  end

  def max_one_measurement
    errors.add(:offer_measurements, "More than #{MAX_MEASUREMENT} measurement can't be accepted") if
      offer_measurements.size > 1
  end
end
