# frozen_string_literal: true

class V1::Users::SubCategoriesController < V1::Users::BaseController
  def index
    sc = SubCategory.all.order(serial_no: :asc)
    render json: { sub_categories: sc }
  end
end
