# frozen_string_literal: true

class Offer < ApplicationRecord
  MAX_QUOTES = 3

  belongs_to :designer
  belongs_to :request

  has_many :offer_quotations, dependent: :destroy

  validates :designer_id, uniqueness: { scope: :request_id }
  validates :designer_id, :request_id, presence: true
  validate :max_number_of_quotations

  accepts_nested_attributes_for :offer_quotations

  def self.find_for_user(user)
    joins(:request).where(requests: { user: user })
  end

  def self.find_for_user_and_request(user, request_id)
    joins(:request).where(requests: { user: user, id: request_id })
  end

  private

  def max_number_of_quotations
    errors.add(:offer_quotations, "More than #{MAX_QUOTES} quotations can't be accepted") if
      offer_quotations.size > MAX_QUOTES
  end
end
