# frozen_string_literal: true

class V1::Users::UserFavoriteProductsController < V1::Users::BaseController
  def create
    ufp = current_user.user_favorite_products.new(product_params)
    if ufp.save
      render json: { message: 'Added to wishlist' }, status: 201
    else
      render json: { errors: ufp.errors.messages }, status: 400
    end
  end

  private

  def product_params
    params.require(:product).permit(:product_id)
  end
end
