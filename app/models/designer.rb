# frozen_string_literal: true

class Designer < ApplicationRecord
  include Authenticable

  has_secure_password

  has_one :designer_store_info
  has_one :designer_finance_info
  has_many :designer_categorizations
  has_many :sub_categories, through: :designer_categorizations
  has_many :products
  has_many :request_designers

  validates :full_name, :email, :mobile_number, :location, presence: true
  validates :email, :mobile_number, uniqueness: { case_sensitive: false }

  before_create :generate_pin

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
