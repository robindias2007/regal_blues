# frozen_string_literal: true

class V1::Users::ProductsController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    if invalid_price_params?
      render json: { errors: ['Bad Request. Both price filters must be present'] }, status: 400
    else
      server = IndexService.new(params[:category_id], params[:price_low], params[:price_high])
      products = server.products
      if products.present?
        sort_and_serve products
      else
        render json: { errors: { message: 'No products found!' } }, status: 404
      end
    end
  end

  def show
    product = Product.find(params[:id])
    render json: product, serializer: V1::Users::ProductShowSerializer
  end

  private

  def sort_and_serve(products)
    if params[:sort].present?
      sort_products(products)
    else
      render json:            products.order(created_at: :desc).limit(10),
             each_serializer: V1::Users::ProductsSerializer
    end
  end

  def sort_products(products)
    products = if params[:sort] == 'price-asc'
                 products.order(selling_price: :asc).limit(10)
               elsif params[:sort] == 'price-desc'
                 products.order(selling_price: :desc).limit(10)
               end
    render json: products, each_serializer: V1::Users::ProductsSerializer
  end

  def invalid_price_params?
    (params[:price_low].present? && params[:price_high].nil?) ||
      (params[:price_low].nil? && params[:price_high].present?)
  end
end
