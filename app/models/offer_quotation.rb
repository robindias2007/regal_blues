# frozen_string_literal: true

class OfferQuotation < ApplicationRecord
  belongs_to :offer

  validates :price, :description, presence: true
  validates :description, length: { in: 4..480 }
  validates :price, numericality: true
end
