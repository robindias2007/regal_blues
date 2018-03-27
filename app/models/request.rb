# frozen_string_literal: true

class Request < ApplicationRecord
  extend Enumerize
  include PushNotification

  belongs_to :user
  belongs_to :sub_category
  belongs_to :address
  has_many :request_images, dependent: :destroy
  has_many :request_designers, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :notifications, as: :notificationable

  has_one :request_chat, dependent: :destroy

  validates :name, :size, :timeline, presence: true
  # validates :request_images, :request_designers, length: { minimum: 1, maximum: 100 }
  validates :name, length: { in: 4..60 }, uniqueness: { case_sensitive: false, scope: :user_id }
  validates :timeline, numericality: { only_integer: true }
  validates :min_budget, numericality: true, allow_nil: true
  validates :max_budget, numericality: { greater_than_or_equal_to: 0,
    less_than: 10_000_000 }
  validates :address, presence: true, if: proc { |req| Address.ids_for(req.user_id) }

  accepts_nested_attributes_for :request_images
  accepts_nested_attributes_for :request_designers

  enumerize :size, in: %w[xs-s s-m m-l l-xl xl-xxl], scope: true, predicates: true
  enumerize :status, in: %i[active pending unapproved confirmed], scope: true, predicates: true, default: :active
  enumerize :origin, in: %i[upload search designer]

  def self.find_for(designer)
    joins(:request_designers).where(request_designers: { designer: designer })
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update(:"#{attr}" => false) : update(:"#{attr}" => true)
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      column_names = %w(name description size max_budget timeline)
      csv << column_names
      all.each do |request|
        csv << request.attributes.values_at(*column_names).insert(-1, request.user.username)
      end
    end
  end

  def send_request_mail
    body = "You have a new request by #{ self.user.full_name }"
    message = "New Request -  You have a new request #{self.name} by user #{self.user.full_name}."
    extra_data = {type: "Request", id: self.id}
    self.request_designers.each do |request_designer|
      NotificationsMailer.new_request(self.user, request_designer.designer).deliver_later
      begin
        SmsService.send_message_notification(request_designer.designer.mobile_number, message)
        request_designer.designer.notifications.create(body: body, notificationable_type: "Request", notificationable_id: self.id)
        Request.new.send_notification(request_designer.designer.devise_token, body, " ", extra_data)
      rescue        
      end
    end
    # After Creating Request Sending a message in chat
    message_body = "Hi! We have received your request. Designers on our platform will review it and send you the offers accordingly. Thank You!"
    if self.user.conversations.present?
      message = Message.create(body:message_body, conversation_id:self.user.conversations.first.id, sender_id:Support.first.common_id)
      self.user.update(updated_at:DateTime.now)  
    else
      convo = Conversation.create(receiver_id:Support.first.common_id, receiver_type:"support", conversationable_id:self.user.id, conversationable_type:"User")   
      message = Message.create(body:message_body, conversation_id:convo.id, sender_id:Support.first.common_id)
      self.user.update(updated_at:DateTime.now)
    end
  end
end
