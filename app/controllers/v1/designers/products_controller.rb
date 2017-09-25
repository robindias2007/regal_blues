# frozen_string_literal: true

class V1::Designers::ProductsController < V1::Designers::BaseController
  def create
    product = current_designer.products.new(product_params)
    product.build_product_info(product_info_params)
    if product.save
      render json: { message: 'Product saved successfully' }, status: 201
    else
      render json: { errors: product.errors.messages }, status: 400
    end
  end

  def index
    products = current_designer.products.includes(:images, :sub_category).limit(20)
    if products.present?
      if params[:sort].present?
        sort_products(products)
      else
        render_default_sorted_products(products)
      end
    else
      render json: { message: 'No products found. Please start by creating one!' }, status: 404
    end
  end

  def show
    product = current_designer.products.find(params[:id])
    render json: product, serializer: V1::Designers::ProductShowSerializer
  end

  def toggle_active
    product = current_designer.products.find(params[:id])
    if product.toggle(:active)
      render json: { message: 'Product state successfully changed' }, status: 200
    else
      render json: { errors: ['Something went wrong'] }, status: 400
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :selling_price, :sub_category_id,
      images_attributes: %i[image])
  end

  def product_info_params
    params.require(:product).permit(product_info_attributes: %i[color fabric care notes work])
          .require(:product_info_attributes).first
  end

  def first_instance_of(products)
    ActiveModelSerializers::SerializableResource.new(products.first,
      serializer: V1::Designers::ProductShowSerializer)
  end

  def sort_products(products)
    if params[:sort] == 'price-asc'
      render json: products.order(selling_price: :asc),
        each_serializer: V1::Designers::ProductIndexSerializer, meta: first_instance_of(products)
    elsif params[:sort] == 'price-desc'
      render json: products.order(selling_price: :desc),
        each_serializer: V1::Designers::ProductIndexSerializer, meta: first_instance_of(products)
    end
  end

  def render_default_sorted_products(products)
    render json: products.order(created_at: :desc),
      each_serializer: V1::Designers::ProductIndexSerializer, meta: first_instance_of(products)
  end
end
