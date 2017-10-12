# frozen_string_literal: true

class OfferMeasurement < ApplicationRecord
  belongs_to :offer_quotation

  validates :data, presence: true
end
