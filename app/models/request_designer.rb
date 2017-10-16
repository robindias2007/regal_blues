# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  belongs_to :request
  belongs_to :designer

  validates :designer_id, uniqueness: { scope: :request_id }

  def self.find_for(request_id, designer)
    find_by(request_id: request_id, designer: designer)
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update(:"#{attr}" => false) : update(:"#{attr}" => true)
  end
end
