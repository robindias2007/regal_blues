# frozen_string_literal: true

class V1::Users::DesignersController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    designers = conditional_render(params[:min_order], params[:max_order])
    render json: designers, each_serializer: V1::Users::TopDesignersSerializer
  end

  def show
    designer = Designer.includes(:designer_store_info).find(params[:id])
    render json: designer, serializer: V1::Users::DesignerShowSerializer
  end

  private

  def conditional_render(min_order, max_order)
    if min_order.present?
      Designer.min_order_greater_than(min_order)
    elsif max_order.present?
      Designer.max_order_greater_than(max_order)
    else
      Designer.included_releated_associations.all
    end.order_alphabetically
  end
end
