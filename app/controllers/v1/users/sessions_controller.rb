# frozen_string_literal: true

class V1::Users::SessionsController < ApplicationController
  skip_before_action :authenticate

  def create
    user = User.find_for_auth(auth_params[:login])
    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { jwt: jwt }, status: 200
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  private

  def auth_params
    params.permit(:login, :password)
  end
end
