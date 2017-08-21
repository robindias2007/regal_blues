# frozen_string_literal: true

class V1::Users::RequestsController < V1::Users::BaseController
  def create
    request = current_user.requests.build(request_params)
    if request.save
      render json: { message: 'Request saved successfully' }, status: 201
    else
      render json: { errors: request.errors.messages }, status: 400
    end
  end

  def index
    requests = current_user.requests.order(created_at: :desc).limit(20)
    render json: { requests: requests }
  end

  def show
    request = current_user.requests.find(params[:id])
    render json: { request: request }
  end

  private

  def request_params
    params.require(:request).permit(:name, :size, :min_budget, :max_budget, :timeline,
      :description, :sub_category_id)
  end
end
