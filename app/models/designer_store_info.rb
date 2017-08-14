# frozen_string_literal: true

class DesignerStoreInfo < ApplicationRecord
  belongs_to :designer

  validates :display_name, :registered_name, :pincode, :country, :state, :city, :address_line_1, :contact_number,
    :min_order_price, :processing_time, presence: true

  validates :display_name, :registered_name,  uniqueness: { case_sensitive: false }

  validates :pincode, length: { in: 5..6 }, numericality: { only_integer: true }
  validates :processing_time, numericality: { only_integer: true }
end
