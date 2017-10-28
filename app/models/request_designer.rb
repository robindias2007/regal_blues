# frozen_string_literal: true

class RequestDesigner < ApplicationRecord
  MAX_DESIGNERS_INVOLVED = 1

  belongs_to :request
  belongs_to :designer

  validates :designer_id, uniqueness: { scope: :request_id }

  validate :max_three_involved

  def self.find_for(request_id, designer)
    find_by(request_id: request_id, designer: designer)
  end

  def safe_toggle!(attr)
    public_send(attr) == true ? update(:"#{attr}" => false) : update(:"#{attr}" => true)
  end

  private

  def max_three_involved
    errors.add(:involved, 'three designers are already involved for this request') if involved_count_exceeds
  end

  def involved_count_exceeds
    request.request_designers.where(involved: true).count > MAX_DESIGNERS_INVOLVED
  end
end
