# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :designer
  belongs_to :user
  belongs_to :offer_quotation
end
