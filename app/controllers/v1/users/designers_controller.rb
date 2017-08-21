# frozen_string_literal: true

class V1::Users::DesignersController < V1::Users::BaseController
  def index
    designers = Designer.all.order(full_name: :asc)
    render json: { designers: designers }
  end
end
