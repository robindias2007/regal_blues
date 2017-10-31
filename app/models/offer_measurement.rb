# frozen_string_literal: true

class OfferMeasurement < ApplicationRecord
  belongs_to :offer_quotation

  validates :data, presence: true

  before_save :capitalize_data

  private

  def capitalize_data
    data.fetch(:tags).each(&:titleize)
  end
end
