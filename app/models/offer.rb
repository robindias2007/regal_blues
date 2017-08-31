# frozen_string_literal: true

class Offer < ApplicationRecord
  belongs_to :designer
  belongs_to :request

  validates :designer_id, uniqueness: { scope: :request_id }

  validates :designer_id, :request_id, presence: true
end
