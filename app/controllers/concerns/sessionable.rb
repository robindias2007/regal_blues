# frozen_string_literal: true

module Sessionable
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate

    def create
      resource = resource_class.find_for_auth(auth_params[:login])
      return resource_not_found if resource.nil?
      if resource && resource.authenticate(auth_params[:password])
        issue_jwt(resource)
      else
        render json: { errors: 'Unauthorized' }, status: 401
      end
    end

    private

    def resource_class
      @reource_class ||= controller_path.classify.split('::').second.singularize.constantize
    end

    def auth_params
      params.permit(:login, :password)
    end

    def issue_jwt(resource)
      jwt = Auth.issue(resource: resource.id)
      render json: { jwt: jwt }, status: 200
    end

    def resource_not_found
      render json: { errors: 'Resource not found' }, status: 404
    end
  end
end
