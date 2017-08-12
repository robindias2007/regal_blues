# frozen_string_literal: true

class V1::Users::SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    user = User.find_by(email: auth_params[:email])
    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { jwt: jwt }, status: 200
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  private

  def auth_params
    params.permit(:email, :password)
  end
end
