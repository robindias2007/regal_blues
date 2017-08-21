# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  belongs_to :request
  belongs_to :designer
end
