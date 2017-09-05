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
    products = current_designer.products.includes(:images).order(created_at: :desc).limit(20)
    render json: products, include: %i[sub_category images], each_serializer: V1::Designers::ProductIndexSerializer
  end

  def show
    product = current_designer.products.find(params[:id])
    render json: product, include: %i[images sub_category product_info]
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
end
