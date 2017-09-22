# frozen_string_literal: true

class V1::Users::ProductsController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    products = if params[:category_id].nil?
                 Product.all
               else
                 Product.where(sub_category_id: params[:category_id])
               end.order(name: :asc).limit(30)
    render json: products, each_serializer: V1::Users::ProductsSerializer
  end
end
