# frozen_string_literal: true

class DesignerStoreInfo < ApplicationRecord
  PINCODE_API_KEY = '579b464db66ec23bdd000001ab7466db0d0c45907a8567a5fd631572'
  PINCODE_RESOURCE_ID = '6176ee09-3d56-4a3b-8115-21841576b2f6'
  belongs_to :designer

  validates :display_name, :registered_name, :pincode, :country, :state, :city, :address_line_1,
    :min_order_price, :processing_time, presence: true

  validates :display_name, :registered_name,  uniqueness: { case_sensitive: false }

  validates :pincode, length: { in: 5..6 }, numericality: { only_integer: true }
  validates :min_order_price, numericality: { greater_than: 2000 }
  validates :processing_time, numericality: { only_integer: true }

  validate :valid_pincode

  def self.search_for(query)
    where('similarity(display_name, ?) > 0.15', query).order("similarity(display_name,
      #{ActiveRecord::Base.connection.quote(query)}) DESC")
  end

  private

  def valid_pincode
    base_uri = 'https://api.data.gov.in/resource/'
    url = "#{base_uri}#{PINCODE_RESOURCE_ID}?format=json&api-key=#{PINCODE_API_KEY}&filters[pincode]=#{pincode}"
    response = HTTParty.get(url)
    data = JSON.parse(response.body)
    fields = data['records']
    errors.add(:pincode, 'not a valid pincode') if fields.blank?
  end
end
