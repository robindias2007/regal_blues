# frozen_string_literal: true

module BaseHelpers
  extend ActiveSupport::Concern

  included do
    before_action :authenticate

    define_method :"current_#{controller_path.classify.split('::').second.singularize.downcase}" do
      return unless auth_present?
      resource = resource_class.find(auth['resource'])
      @current_resource ||= resource if resource
    end

    def logged_in?
      current_resource.present?
    end

    def authenticate
      render json: { errors: ['Unauthorized'] }, status: 401 unless logged_in?
    end

    def current_user
      user_id = request.headers['HTTP_USER_ID'].presence
      if user_id
        @current_user ||= User.find(user_id)
      end
    end

    private

    def resource_class
      @reource_class ||= controller_path.classify.split('::').second.singularize.constantize
    end

    def current_resource
      public_send("current_#{resource_class.name.downcase}")
    end

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
end
