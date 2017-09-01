# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  def index
    requests = Request.joins(:request_designers).where(request_designers: { designer: current_designer })
    render json: { requests: requests }
  end

  def show
    return not_an_owner unless can_see?
    request = Request.find(params[:id])
    render json: { request: request }
  end

  private

  def not_an_owner
    render json: { errors: 'Unauthorized' }, status: 403
  end

  def can_see?
    current_designer.request_designers.pluck(:request_id).include? params[:id]
  end
end
