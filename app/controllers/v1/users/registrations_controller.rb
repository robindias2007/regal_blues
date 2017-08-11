# frozen_string_literal: true

class V1::Users::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def confirm
    token = request.headers['Confirmation-Token']
    user = User.find_by(confirmation_token: token)
    if user && user.valid_confirmation_token?
      user.mark_as_confirmed!
      render json: { message: 'User confirmed successfully' }, status: 200
    else
      render json: { errors: 'Invalid Token' }, status: 404
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar)
  end
end
