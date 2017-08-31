# frozen_string_literal: true

class OfferMeasurement < ApplicationRecord
  belongs_to :offer

  validates :data, presence: true
end
