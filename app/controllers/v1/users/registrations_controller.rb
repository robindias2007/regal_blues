# frozen_string_literal: true

class V1::Users::RegistrationsController < V1::Users::BaseController
  skip_before_action :authenticate, only: %i[create confirm resend_confirmation
                                             send_reset_password_instructions reset_password]

  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully' }, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 400
    end
  end

  def confirm
    token = params[:token]
    user = User.find_by(confirmation_token: token)
    formatted_response_if(user && user.valid_confirmation_token?,
      ['User confirmed successfully', 200], ['Invalid Token', 404]) do
      user.mark_as_confirmed!
    end
  end

  def resend_confirmation
    user = User.find_by(email: params[:email])
    formatted_response_if(user,
      ['Confirmation instructions resent successfully', 200], ['User not found or invalid email', 404]) do
      user.send(:send_confirmation_email)
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
    user = User.find_by(reset_password_token: token)
    if user && user.valid_reset_password_token?
      user.update_reset_details!
      jwt = Auth.issue(user: user.id)
      render json: { message: 'Valid password reset token', jwt: jwt }, status: 200
    else
      render json: { errors: 'Invalid token' }, status: 404
    end
  end

  def update_password
    if current_user && current_user.update(password: params[:password])
      render json: { message: 'Password Updated' }, status: 200
    else
      render json: { errors: 'Something went wrong' }, status: 400
    end
  end

  def update_mobile_number
    if current_user && current_user.update(mobile_number: params[:mobile_number])
      render json: { message: 'Mobile number Updated' }, status: 200
    else
      render json: { errors: 'Something went wrong' }, status: 400
    end
  end

  def resend_otp
    current_user.send_otp
    render json: { message: 'OTP resent successfully' }, status: 200
  end

  def verify_otp
    sent_otp = Redis.current.get(current_user.id)
    if sent_otp == verify_otp_params
      current_user.update(verified: true)
      render json: { message: 'Mobile number verified' }, status: 200
    else
      render json: { errors: 'Wrong OTP' }, status: 400
    end
  end

  private

  def user_params
    params.permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar)
  end

  def reset_password_params
    params.permit(:login)
  end

  def verify_otp_params
    params.require(:otp)
  end
end
