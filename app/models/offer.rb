# frozen_string_literal: true

class Offer < ApplicationRecord
  MAX_QUOTES = 3

  belongs_to :designer
  belongs_to :request

  has_one :offer_measurement

  has_many :offer_quotations

  validates :designer_id, uniqueness: { scope: :request_id }
  validates :designer_id, :request_id, presence: true
  validate :max_number_of_quotations

  accepts_nested_attributes_for :offer_quotations

  def max_number_of_quotations
    errors.add(:offer_quotations, "More than #{MAX_QUOTES} quotations can't be accepted") if
      offer_quotations.size > MAX_QUOTES
  end
end
