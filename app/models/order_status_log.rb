# frozen_string_literal: true

class OrderStatusLog < ApplicationRecord
  belongs_to :order
end
