# frozen_string_literal: true

class V1::Designers::SessionsController < V1::Designers::BaseController
  skip_before_action :authenticate

  def create
    designer = Designer.find_for_auth(auth_params[:login])
    if designer.authenticate(auth_params[:password])
      issue_jwt(designer)
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  private

  def auth_params
    params.permit(:login, :password)
  end

  def issue_jwt(designer)
    jwt = Auth.issue(designer: designer.id)
    render json: { jwt: jwt }, status: 200
  end
end
