# frozen_string_literal: true

class Offer < ApplicationRecord
  MAX_QUOTES = 3

  belongs_to :designer
  belongs_to :request

  has_many :offer_quotations, dependent: :destroy

  # validates :designer_id, uniqueness: { scope: :request_id }
  validates :designer_id, :request_id, presence: true
  validate :max_number_of_quotations
  validate :check_for_time

  accepts_nested_attributes_for :offer_quotations, allow_destroy: true

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

  def check_for_time
    errors.add(:designer_id, "Can't accept this offer as the time has exceeded") if time_expired_to_create_offer?
  end

  def time_expired_to_create_offer?
    rd = RequestDesigner.find_by(designer: designer, request: request)
    (rd.involved == true) && (rd.updated_at < (Time.zone.now - 48.hours))
  end
end
