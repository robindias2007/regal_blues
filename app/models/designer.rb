# frozen_string_literal: true

class Designer < ApplicationRecord
  include Authenticable
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

  has_many :conversations, as: :personable, dependent: :destroy

  validates :full_name, :email, :mobile_number, :location, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }

  scope :order_alphabetically, -> { order(full_name: :asc) }

  before_create :generate_pin

  enumerize :live_status, in: %i[unapproved approved blocked], scope: true, predicates: true, default: :unapproved

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
end
