# frozen_string_literal: true

class V1::Users::HomeController < V1::Users::BaseController
  def mobile
    top_designers = Designer.order('RANDOM()').limit(6)
    requests = current_user.requests.order(created_at: :desc).limit(3)
    recommendations = Product.order('RANDOM()').limit(6)
    render json: { top_designers: top_designers, requests: requests, recommendations: recommendations }
  end
end
