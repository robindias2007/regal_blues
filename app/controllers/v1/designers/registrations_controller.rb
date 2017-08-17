# frozen_string_literal: true

class V1::Designers::RegistrationsController < V1::Designers::BaseController
  skip_before_action :authenticate, only: %i[create confirm resend_confirmation
                                             send_reset_password_instructions reset_password]

  before_action :verify_current_designer, only: %i[update_password resend_otp verify_otp]

  def create
    designer = Designer.new(designer_params)
    if designer.save
      jwt = Auth.issue(designer: designer.id)
      render json: { message: 'Designer created successfully', jwt: jwt }, status: 201
    else
      render json: { errors: designer.errors.full_messages }, status: 400
    end
  end

  def confirm
    token = params[:token]
    designer = Designer.find_by(confirmation_token: token)
    formatted_response_if(designer && designer.valid_confirmation_token?,
      ['Designer confirmed successfully', 200], ['Invalid Token', 404]) do
      designer.mark_as_confirmed!
    end
  end

  def resend_confirmation
    designer = Designer.find_for_auth(resend_confirmation_params[:email])
    formatted_response_if(designer,
      ['Confirmation instructions resent successfully', 200], ['Designer not found or invalid email', 404]) do
      designer.send(:send_confirmation_email)
    end
  end

  def send_reset_password_instructions
    designer = Designer.find_for_auth(reset_password_params[:login])
    formatted_response_if(designer,
      ['Reset password instructions sent successfully', 200], ['Designer not found or invalid email', 404]) do
      designer.send(:send_reset_password_instructions)
    end
  end

  def reset_password
    token = params[:token]
    designer = Designer.find_by(reset_password_token: token)
    if designer && designer.valid_reset_password_token?
      designer.update_reset_details!
      jwt = Auth.issue(designer: designer.id)
      render json: { message: 'Valid password reset token', jwt: jwt }, status: 200
    else
      render json: { errors: 'Designer not found or invalid token' }, status: 404
    end
  end

  def update_password
    current_designer.update(password: params[:password])
    render json: { message: 'Password Updated' }, status: 200
  end

  def resend_otp
    current_designer.send_otp
  end

  def verify_otp
    sent_otp = Redis.current.get(current_designer.id)
    if sent_otp == verify_otp_params
      current_designer.update(verified: true)
      render json: { message: 'Mobile number verified' }, status: 200
    else
      render json: { errors: 'Wrong OTP' }, status: 400
    end
  end

  private

  def designer_params
    params.permit(:email, :password, :full_name, :mobile_number, :location, :avatar)
  end

  def resend_confirmation_params
    params.permit(:email)
  end

  def reset_password_params
    params.permit(:login)
  end

  def verify_otp_params
    params.require(:otp)
  end

  def no_designer_present
    render json: { errors: 'No designer found' }, status: 404
  end

  def verify_current_designer
    return no_designer_present unless current_designer
  end
end
