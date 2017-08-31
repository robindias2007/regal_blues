# frozen_string_literal: true

class Offer < ApplicationRecord
  belongs_to :designer
  belongs_to :request

  has_many :offer_quotations

  validates :designer_id, uniqueness: { scope: :request_id }

  validates :designer_id, :request_id, presence: true

  accepts_nested_attributes_for :offer_quotations
end
