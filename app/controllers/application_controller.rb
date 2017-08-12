# frozen_string_literal: true

class ApplicationController < ActionController::API
  before_action :authenticate

  def logged_in?
    current_user.present?
  end

  def current_user
    return unless auth_present?
    user = User.find(auth['user'])
    @current_user ||= user if user
  end

  def authenticate
    render json: { errors: 'Unauthorized' }, status: 401 unless logged_in?
  end

  def formatted_response_if(condition, success, failure)
    if condition
      yield if block_given?
      render json: { message: success[0] }, status: success[1]
    else
      render json: { errors: failure[0] }, status: failure[1]
    end
  end

  private

  def token
    request.headers['Authorization'].scan(/Bearer(.*)/).flatten.last.strip
  end

  def auth
    Auth.decode(token)
  end

  def auth_present?
    request.headers.fetch('Authorization', '').scan(/Bearer/).flatten.first.present?
  end
end
