# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  include PushNotification

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
    unless self.request.offers.where(designer_id: self.designer_id).present?
      message = "Quote Penalty  - You have missed the 48 hours deadline for submitting offer for request #{self.request.name} by user #{self.request.user.full_name}."

      body = "You failed to quote for #{self.request.name} by #{self.request.user.full_name} after showing interest. You would be charged 500 in your next order as penalty."

      self.designer.notifications.create(body: body, notificationable_type: "Request", notificationable_id: self.request.id)

      SmsService.send_message_notification(self.designer.mobile_number, message)
      NotificationsMailer.penalty(self).deliver
      RequestDesigner.new.send_notification(self.designer.devise_token, body, " ", extra_data)
    end
  end

  def quote_msg(time)
    unless self.request.offers.where(designer_id: self.designer_id).present?
      time = 48-time

      message = "Time Remaining for quotation - You have #{time} hours remaining to send quotation for request #{self.request.name} by user #{self.request.user.full_name}."

      body = "You have shown your interest in #{ self.request.name } by #{ self.request.user.full_name }. You have #{time} hrs to quote for the same."

      SmsService.send_message_notification(self.designer.mobile_number, message)
      NotificationsMailer.interested(self, time).deliver
      RequestDesigner.new.send_notification(self.designer.devise_token, body, " ", extra_data)
      self.designer.notifications.create(body: body, notificationable_type: "Request", notificationable_id: self.request.id)
    end
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

  def extra_data
    return {type: "Request", id: self.request.id} rescue " "
  end

end
