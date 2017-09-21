# frozen_string_literal: true

module Registerable
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate, only: %i[create confirm resend_confirmation
                                               send_reset_password_instructions reset_password]

    def create
      resource = resource_class.new(resource_params)
      if resource.save
        jwt = Auth.issue(resource: resource.id)
        render json: { message: "#{resource_class.name} created successfully", jwt: jwt }, status: 201
      else
        render json: { errors: resource.errors.full_messages }, status: 400
      end
    end

    def confirm
      token = params[:token]
      resource = resource_class.find_by(confirmation_token: token)
      if resource && resource.valid_confirmation_token?
        resource.mark_as_confirmed!
        jwt = Auth.issue(resource: resource.id)
        render json: { message: "#{resource_class.name} confirmed successfully", jwt: jwt }, status: 200
      else
        render json: { errors: 'Invalid Token' }, status: 404
      end
    end

    def resend_confirmation
      resource = resource_class.find_for_auth(resend_confirmation_params[:email])
      formatted_response_if(resource,
        ['Confirmation instructions resent successfully', 200], ['User not found', 404]) do
        resource.send(:send_confirmation_email)
      end
    end

    def send_reset_password_instructions
      resource = resource_class.find_for_auth(reset_password_params[:login])
      formatted_response_if(resource,
        ['Reset password instructions sent successfully', 200], ['resource_class not found or invalid email', 404]) do
        resource.send(:send_reset_password_instructions)
      end
    end

    def reset_password
      token = params[:token]
      resource = resource_class.find_by(reset_password_token: token)
      if resource && resource.valid_reset_password_token?
        resource.update_reset_details!
        jwt = Auth.issue(resource: resource.id)
        render json: { message: 'Valid password reset token', jwt: jwt }, status: 200
      else
        render json: { errors: 'resource_class not found or invalid token' }, status: 404
      end
    end

    def update_password
      if current_resource && current_resource.update(password: params[:password])
        render json: { message: 'Password Updated' }, status: 200
      else
        render json: { errors: ['Something went wrong'] }, status: 400
      end
    end

    def update_mobile_number
      if current_resource && current_resource.update(mobile_number: params[:mobile_number])
        render json: { message: 'Mobile number Updated' }, status: 200
      else
        render json: { errors: ['Something went wrong'] }, status: 400
      end
    end

    def resend_otp
      current_resource.send_otp
      render json: { message: 'OTP resent successfully' }, status: 200
    end

    def verify_otp
      sent_otp = Redis.current.get(current_resource.id)
      if sent_otp == verify_otp_params
        current_resource.update(verified: true)
        render json: { message: 'Mobile number verified' }, status: 200
      else
        render json: { errors: ['Wrong OTP'] }, status: 400
      end
    end

    private

    def resource_class
      @reource_class ||= controller_path.classify.split('::').second.singularize.constantize
    end

    def current_resource
      public_send("current_#{resource_class.name.downcase}")
    end

    def designer_params
      params.permit(:email, :password, :full_name, :mobile_number, :location, :avatar)
    end

    def user_params
      params.permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar)
    end

    def resource_params
      send("#{resource_class.name.downcase}_params")
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
  end
end
