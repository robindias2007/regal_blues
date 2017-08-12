# frozen_string_literal: true

class V1::Users::SessionsController < ApplicationController
  skip_before_action :authenticate, only: :create

  def create
    user = User.find_for_auth(auth_params[:login])
    if user.authenticate(auth_params[:password])
      jwt = Auth.issue(user: user.id)
      render json: { jwt: jwt }, status: 200
    else
      render json: { errors: 'Unauthorized' }, status: 401
    end
  end

  def send_reset_password_instructions
    user = User.find_for_auth(reset_password_params[:login])
    formatted_response_if(user,
      ['Reset password instructions sent successfully', 200], ['User not found or invalid email/username', 404]) do
      user.send(:send_reset_password_instructions)
    end
  end

  def reset_password
    token = params[:token]
    User.find_by(reset_password_token: token)
    formatted_response_if(user && user.valid_reset_password_token?,
      ['Valid password reset token', 200], ['Invalid Token', 404]) do
      user.update_reset_details!
    end
  end

  private

  def auth_params
    params.permit(:login, :password)
  end

  def reset_password_params
    params.permit(:login)
  end
end
