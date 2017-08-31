# frozen_string_literal: true

class OfferQuotation < ApplicationRecord
  belongs_to :offer

  has_many :offer_quotation_galleries

  validates :price, :description, presence: true
  validates :description, length: { in: 4..480 }
  validates :price, numericality: true

  accepts_nested_attributes_for :offer_quotation_galleries
end
