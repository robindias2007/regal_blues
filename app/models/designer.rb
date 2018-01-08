# frozen_string_literal: true

class Designer < ApplicationRecord
  include Authenticable
  include Jsonable
  extend Enumerize

  has_one :designer_store_info, dependent: :destroy
  has_one :designer_finance_info, dependent: :destroy
  has_many :designer_categorizations, dependent: :destroy
  has_many :sub_categories, through: :designer_categorizations, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :request_designers, dependent: :destroy
  has_many :requests, through: :request_designers, dependent: :nullify
  has_many :offers, dependent: :nullify
  has_many :orders, dependent: :nullify

  has_one :support_chat, dependent: :destroy
  has_many :request_chats, dependent: :destroy
  has_many :offer_quotation_chats, dependent: :destroy

  has_many :sent_conversations, as: :sender, dependent: :destroy, class_name: 'Conversation'
  has_many :received_conversations, as: :receiver, dependent: :destroy, class_name: 'Conversation'

  has_many :conversations, as: :conversationable
  has_many :notifications, as: :resourceable

  validates :full_name, :email, :mobile_number, :location, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }

  scope :order_alphabetically, -> { order(full_name: :asc) }

  before_create :generate_pin

  after_create :send_welcome_email

  enumerize :live_status, in: %i[unapproved approved blocked], scope: true, predicates: true, default: :approved

  mount_base64_uploader :avatar, AvatarUploader

  accepts_nested_attributes_for :designer_store_info

  def self.find_for_category(category_id)
    joins(:designer_categorizations).where(designer_categorizations: { sub_category_id: category_id })
  end

  def self.included_releated_associations
    includes(:sub_categories, :designer_categorizations, :designer_store_info)
  end

  def self.min_order_greater_than(min_value)
    included_releated_associations.joins(:designer_store_info)
                                  .where(designer_store_infos: { min_order_price: min_value.to_i..Float::INFINITY })
  end

  def self.max_order_greater_than(max_value)
    included_releated_associations.joins(:designer_store_info)
                                  .where(designer_store_infos: { min_order_price: 0..max_value.to_i })
  end

  # Uncomment second line and replace `find_by` with `where` if you want a list of users instead of just one user
  def self.search_for(query)
    find_by('similarity(email, ?) > 0.15', query)
    # .order("similarity(email, #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  def notify_request(request)
    # request
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update!(:"#{attr}" => false) : update!(:"#{attr}" => true)
  end

  def send_update_otp(number)
    return if Rails.env.test? || Rails.env.development? || Rails.env.production?
    otp = Array.new(6) { rand(10) }.join
    Redis.current.set(id, number: number, otp: otp)
    SmsService.send_otp_to_number(number, otp)
  end

  def autocompleter
    ["#{designer_store_info&.display_name} --> #{full_name} (#{email})", nil]
  end

  def as_offer_json
    self.offers.collect{|offer| {
      id: offer.id,
      designer_id: offer.designer_id,
      request_id: offer.request_id,
      created_at: offer.created_at,
      updated_at: offer.updated_at,
      message_count: msg_count(offer),
      unread_message_count: unread_msg_count(offer)
    }}
  end

  private

  def generate_pin
    return if pin.present?
    self.pin = generate_pin_token
  end

  def generate_pin_token
    loop do
      token = SecureRandom.hex(2).tr('lIO0', 'sxyz').upcase
      break token unless Designer.find_by(pin: token)
    end
  end

  def send_welcome_email
    NotificationsMailer.send_email(self).deliver
    begin
      body = "Welcome to Custumise!"
      self.notifications.create(body: body, notification_type: "order")
      Designer.new.send_notification(self.devise_token, "Welcome", body)
    rescue
    end
     
  end
end
