# frozen_string_literal: true

class OrderOption < ApplicationRecord
  belongs_to :order
  belongs_to :image, optional: true
end
