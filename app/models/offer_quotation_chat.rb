# frozen_string_literal: true

class OfferQuotationChat < ApplicationRecord
  belongs_to :user
  belongs_to :designer
  belongs_to :offer_quotation

  has_many :conversations, as: :chattable, dependent: :destroy
end
