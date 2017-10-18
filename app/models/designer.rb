# frozen_string_literal: true

class Designer < ApplicationRecord
  include Authenticable

  has_one :designer_store_info, dependent: :destroy
  has_one :designer_finance_info, dependent: :destroy
  has_many :designer_categorizations, dependent: :destroy
  has_many :sub_categories, through: :designer_categorizations, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :request_designers, dependent: :destroy
  has_many :offers, dependent: :nullify
  has_many :orders, dependent: :nullify

  validates :full_name, :email, :mobile_number, :location, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }

  scope :order_alphabetically, -> { order(full_name: :asc) }

  before_create :generate_pin

  mount_base64_uploader :avatar, AvatarUploader

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
