# frozen_string_literal: true

class V1::Users::UserFavoriteDesignersController < V1::Users::BaseController
  def create
    binding.pry
    ufd = current_user.user_favorite_designers.new(designer_params)
    if ufd.save
      render json: { message: 'Added to wishlist' }, status: 201
    else
      render json: { errors: ufp.errors.messages }, status: 400
    end
  end

  private

  def designer_params
    params.require(:designer).permit(:designer_id)
  end
end
