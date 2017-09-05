# frozen_string_literal: true

class OfferQuotationGallery < ApplicationRecord
  belongs_to :offer_quotation

  has_many :images, as: :imageable

  validates :name, presence: true, uniqueness: { scope: :offer_quotation_id, case_sensitive: false }

  accepts_nested_attributes_for :images
end