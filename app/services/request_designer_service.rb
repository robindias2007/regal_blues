# frozen_string_literal: true

class RequestDesignerService
  def self.notify_about(request)
    designers = Designer.joins(:request_designers).where(request_designers: { request_id: request.id })
    designers.all.each do |designer|
      designer.notify_request(request) # Move this into a background task later
    end
  end
end
