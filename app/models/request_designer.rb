# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  belongs_to :request
  belongs_to :designer

  validates :designer_id, uniqueness: { scope: :request_id }
end
