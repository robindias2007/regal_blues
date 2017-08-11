# frozen_string_literal: true

class V1::Users::RegistrationsController < ApplicationController
  def create
    user = User.new(user_params)
    formatted_message(user.save, ['User created successfully', 200], [user.errors.full_messages, 400])
  end

  def confirm
    token = params[:token]
    user = User.find_by(confirmation_token: token)
    formatted_message(user && user.valid_confirmation_token?,
      ['User confirmed successfully', 200], ['Invalid Token', 404]) do
      user.mark_as_confirmed!
    end
  end

  def resend_confirmation
    user = User.find_by(email: params[:email])
    formatted_message(user,
      ['Confirmation instructions resent successfully', 200], ['User not found or invalid email', 404]) do
      user.send(:send_confirmation_email)
    end
  end

  private

  def user_params
    params.permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar)
  end
end
