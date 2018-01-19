# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  MAX_DESIGNERS_INVOLVED = 4

  belongs_to :request
  belongs_to :designer

  validates :designer_id, uniqueness: { scope: :request_id }

  validate :max_four_involved

  def self.find_for(request_id, designer)
    find_by(request_id: request_id, designer: designer)
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update(:"#{attr}" => false) : update(:"#{attr}" => true)
  end

  def penalty_msg
    message = "Quote Penalty  - You have missed the 48 hours deadline for submitting offer for request #{self.request.name} by user #{self.request.user.full_name}."
    SmsService.send_message_notification(self.designer.mobile_number, message)
  end

  private

  def max_four_involved
    errors.add(:involved, 'four designers are already involved for this request') if involved_count_exceeds
  end

  def involved_count_exceeds
    request.request_designers.where(involved: true).count > MAX_DESIGNERS_INVOLVED
  end

  def request_designer_params
    params.permit(:email, :password, :full_name, :mobile_number, :location, :avatar, :live_status)
  end

end
