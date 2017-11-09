# frozen_string_literal: true

class OrderPayment < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validates :price, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
