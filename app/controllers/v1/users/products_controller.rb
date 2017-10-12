# frozen_string_literal: true

class V1::Users::ProductsController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    return invalid_price_params if invalid_price_params?
    server = IndexService.new(params[:category_id], params[:price_low], params[:price_high], params[:designer_id])
    products = products_to_render(server)
    check_and_render(products)
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
      render json:            products.order(created_at: :desc),
             each_serializer: V1::Users::ProductsSerializer, meta: max_and_min_price_of(products)
    end
  end

  def sort_products(products)
    products = if params[:sort] == 'price-asc'
                 products.order(selling_price: :asc)
               elsif params[:sort] == 'price-desc'
                 products.order(selling_price: :desc)
               end
    render json: products, each_serializer: V1::Users::ProductsSerializer, meta: max_and_min_price_of(products)
  end

  def max_and_min_price_of(products)
    max = products.maximum(:selling_price)
    min = products.minimum(:selling_price)
    { max: max, min: min }
  end

  def invalid_price_params?
    (params[:price_low].present? && params[:price_high].nil?) ||
      (params[:price_low].nil? && params[:price_high].present?)
  end

  def invalid_price_params
    render json: { errors: ['Bad Request. Both price filters must be present'] }, status: 400
  end

  def products_to_render(server)
    if params[:designer_id].present?
      server.designer_products
    else
      server.products
    end
  end

  def check_and_render(products)
    if products.present?
      sort_and_serve products
    else
      render json: { errors: { message: 'No products found!' } }, status: 404
    end
  end
end
