# frozen_string_literal: true

module Registerable
  extend ActiveSupport::Concern
  extend PushNotification

  included do
    skip_before_action :authenticate, only: %i[create confirm resend_confirmation people
                                               send_reset_password_instructions reset_password]

    def create
      delete_extra_user_params if resource_class == User
      resource = resource_class.new(resource_params) 
      if resource.save
        jwt = Auth.issue(resource: resource.id)
        render json: { message: "#{resource_class.name} created successfully", jwt: jwt }, status: 201
      else
        render json: { errors: resource.errors.full_messages }, status: 400
      end
    end

    def people
      people = {
        designers:  ['Sangeeta Baishya', 'Twinkle Rathore'],
        developers: ['Pavan Prakash', 'Ashish Khobragade', 'Ankit Singh']
      }
      render json: people
    end

    def confirm
      token = params[:token]
      resource = resource_class.find_by(confirmation_token: token)
      if resource && resource&.valid_confirmation_token?
        resource.mark_as_confirmed!
        jwt = Auth.issue(resource: resource.id)
        begin
          body = "Your email has been verified and your account is active now."
          extra_data = {type: resource.class.name, id: resource.id}
          NotificationsMailer.send_confirmed_email(resource).deliver
          resource.notifications.create(body: body, notificationable_type: resource.class.name, notificationable_id: resource.id)
          Registerable.send_notification(resource.devise_token, body, "", extra_data)
        rescue 
        end

        if resource_class == User
          redirect_to Rails.application.secrets[:user_url], status: 301
        else
          redirect_to Rails.application.secrets[:designer_url], status: 301
        end 
        #render json: { message: "#{resource_class.name} confirmed successfully", jwt: jwt }, status: 200
      else
        if resource_class == User
          redirect_to Rails.application.secrets[:user_url], status: 301
        else
          redirect_to Rails.application.secrets[:designer_url], status: 301
        end 
        #render json: { errors: 'Invalid Token' }, status: 404
      end
    end

    def resend_confirmation
      resource = resource_class.find_for_auth(resend_confirmation_params[:email])
      if resource.confirmation_token.nil?
        render json: { message: 'email already verified' }, status: 200
      else
        formatted_response_if(resource,
          ['Confirmation instructions resent successfully', 200], ['User not found', 404]) do
          resource.send(:send_confirmation_email)
        end
      end
    end

    def send_reset_password_instructions
      resource = resource_class.find_for_auth(reset_password_params[:login] || resend_confirmation_params[:email])
      formatted_response_if(resource,
        ['Reset password instructions sent successfully', 200], ['resource_class not found or invalid email', 404]) do
        resource.send(:send_reset_password_instructions)
      end
    end

    def reset_password
      token = params[:token]
      resource = resource_class.find_by(email: token)
      if resource && resource&.email?
        resource.update_reset_details!
        jwt = Auth.issue(resource: resource.id)
        NotificationsMailer.password_change(resource).deliver
        #render json: { message: 'Valid password reset token', jwt: jwt }, status: 200
        if resource_class == User
          redirect_to Rails.application.secrets[:user_url], status: 301
        else
          redirect_to Rails.application.secrets[:designer_url], status: 301
        end 
      else
        if resource_class == User
          redirect_to Rails.application.secrets[:user_url], status: 301
        else
          redirect_to Rails.application.secrets[:designer_url], status: 301
        end 
        #render json: { errors: 'resource_class not found or invalid token' }, status: 404
      end
    end

    def update_password
      # return wrong_old_password unless matches_password(params[:password])
      if current_resource && current_resource&.update(password: params[:password])
        NotificationsMailer.password_change(current_resource).deliver
        render json: { message: 'Password Updated' }, status: 200
      else
        render json: { errors: current_resource.errors, message: ['Something went wrong'] }, status: 400
      end
    end

    def update_mobile_number
      if current_resource && current_resource&.update(mobile_number: params[:mobile_number])
        render json: { message: 'Mobile number Updated' }, status: 200
      else
        render json: { errors: current_resource.errors, message: ['Something went wrong'] }, status: 400
      end
    end

    def update_membership
      if current_resource.start_date.present?
        current_resource.update(redeem: params[:redeem])
        render json: { message: 'Membership Updated' }, status: 200
      else
        current_resource.update(start_date: DateTime.now)
      end
      # if current_resource && current_resource&.update(start_date: params[:start_date], redeem:params[:redeem])
      #   render json: { message: 'Membership Updated' }, status: 200
      # else
      #   render json: { errors: current_resource.errors, message: ['Something went wrong'] }, status: 400
      # end
    end

    def update_devise_token
      devise_token = current_resource.update(devise_token: params[:devise_token])
      if devise_token
        render json: { message: 'devise token updated' }, status: 200
      else
        render json: { message: devise_token.errors }, status: 200
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

    def delete_extra_user_params
      params.delete :registration; params.delete :format; params.delete :country_code
    end

    def designer_params
      params.permit(:email, :password, :full_name, :mobile_number, :location, :avatar, :live_status, :gold)
    end

    def user_params
      params.permit(:email, :password, :full_name, :mobile_number, :username, :gender, :avatar, :membership_start_date, :redeem)
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

    def wrong_old_password
      render json: { errors: 'New password does not match the old password' }, status: 400
    end

    def matches_password(password)
      BCrypt::Password.new(current_resource.password_digest) == password
    end
  end
end
