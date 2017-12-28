# frozen_string_literal: true

class V1::Supports::SessionsController < V1::Supports::BaseController
  include Sessionable

  def create
    resource = resource_class.find_for_auth(auth_params[:login])
    if resource
      issue_jwt(resource)
    else
      render json: { errors: ['Invalid Credentials'] }, status: 401
    end
  end
end
