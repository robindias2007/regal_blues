# frozen_string_literal: true

class V1::Users::ProductsController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    if invalid_price_params?
      render json: { errors: ['Bad Request. Both price filters must be present'] }, status: 400
    else
      server = IndexService.new(params[:category_id], params[:sort], params[:price_low], params[:price_high])
      products = server.products
      render json: products, each_serializer: V1::Users::ProductsSerializer
    end
  end

  private

  def invalid_price_params?
    (params[:price_low].present? && params[:price_high].nil?) ||
      (params[:price_low].nil? && params[:price_high].present?)
  end
end
