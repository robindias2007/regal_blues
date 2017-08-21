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

  private

  def request_params
    params.require(:request).permit(:name, :size, :min_budget, :max_budget, :timeline,
      :description, :sub_category_id)
  end
end
