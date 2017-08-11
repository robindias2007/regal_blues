# frozen_string_literal: true

class V1::Users::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      render json: { status: 'User created successfully' }, status: 200
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar)
  end
end
