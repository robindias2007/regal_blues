# frozen_string_literal: true

class V1::Users::SearchController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    products = Product.search_for(params[:q])
    designers = DesignerStoreInfo.search_for(params[:q])
    render json: {
      results: {
        products:  serialize_products(products),
        designers: serialize_designers(designers)
      }
    }
  end

  private

  def serialization_for(list, serializer)
    ActiveModelSerializers::SerializableResource.new(list,
      each_serializer: serializer)
  end

  def serialize_products(products)
    serialization_for(products, V1::Users::SearchProductsSerializer)
  end

  def serialize_designers(designers)
    serialization_for(designers, V1::Users::SearchDesignersSerializer)
  end
end
