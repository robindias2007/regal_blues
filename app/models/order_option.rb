# frozen_string_literal: true

class OrderOption < ApplicationRecord
  belongs_to :order
  belongs_to :offer_quotation_gallery
  belongs_to :image, optional: true
end
