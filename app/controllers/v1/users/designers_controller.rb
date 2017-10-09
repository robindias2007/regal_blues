# frozen_string_literal: true

class V1::Users::DesignersController < V1::Users::BaseController
  skip_before_action :authenticate

  def index
    designers = Designer.all.order(full_name: :asc)
    render json: designers, each_serializer: V1::Users::TopDesignersSerializer
  end
end
