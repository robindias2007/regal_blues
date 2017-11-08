# frozen_string_literal: true

class OfferQuotationGallery < ApplicationRecord
  belongs_to :offer_quotation
  has_many :order_options, dependent: :destroy

  has_many :images, as: :imageable, dependent: :destroy
  has_one :order_option, dependent: :destroy

  validates :name, presence: true, uniqueness: { scope: :offer_quotation_id, case_sensitive: false }

  accepts_nested_attributes_for :images, allow_destroy: true
end
