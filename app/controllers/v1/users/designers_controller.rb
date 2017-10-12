# frozen_string_literal: true

class V1::Users::DesignersController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    designers = Designer.includes(:sub_categories, :designer_categorizations, :designer_store_info)
                        .all.order(full_name: :asc)
    render json: designers, each_serializer: V1::Users::TopDesignersSerializer
  end

  def show
    designer = Designer.includes(:designer_store_info).find(params[:id])
    render json: designer, serializer: V1::Users::DesignerShowSerializer
  end
end
