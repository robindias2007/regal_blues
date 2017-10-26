# frozen_string_literal: true

class DesignerFinanceInfo < ApplicationRecord
  belongs_to :designer

  validates :bank_name, :bank_branch, :ifsc_code, :account_number, :blank_cheque_proof, :personal_pan_number,
    :personal_pan_number_proof, :business_pan_number, :business_pan_number_proof, :tin_number, :tin_number_proof,
    :gstin_number, :gstin_number_proof, :business_address_proof, presence: true

  validates :account_number, :business_pan_number, :personal_pan_number, :tin_number, :gstin_number,
    uniqueness: { case_sensitive: false }

  validate :valid_ifsc_code

  # TODO: Add length and format validations after consulting with legal

  def self.bank_details(ifsc_code)
    base_uri = 'https://ifsc.razorpay.com/'
    url = "#{base_uri}#{ifsc_code}"
    HTTParty.get(url)
  end

  private

  def valid_ifsc_code
    base_uri = 'https://ifsc.razorpay.com/'
    url = "#{base_uri}#{ifsc_code}"
    response = HTTParty.get(url)
    errors.add(:pincode, 'not a valid IFSC code') if response.code == 404
  end
end
