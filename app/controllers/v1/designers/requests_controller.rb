# frozen_string_literal: true

class V1::Designers::RequestsController < V1::Designers::BaseController
  def index
    requests = Request.find_for(current_designer).order(created_at: :desc).limit(20)
    render json: { requests: requests }
  end

  def show
    request = Request.find_for(current_designer).find(params[:id])
    render json: { request: request }
  end
end
