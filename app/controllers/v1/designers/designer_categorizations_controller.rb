# frozen_string_literal: true

class V1::Designers::DesignerCategorizationsController < V1::Designers::BaseController
  def index
    sub_categories = current_designer.sub_categories
    render json: { sub_categories: sub_categories }
  end
end
