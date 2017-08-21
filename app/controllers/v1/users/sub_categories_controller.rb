# frozen_string_literal: true

class V1::Users::SubCategoriesController < V1::Users::BaseController
  def index
    sc = SubCategory.all.order(name: :asc)
    render json: { sub_categories: sc }
  end
end
