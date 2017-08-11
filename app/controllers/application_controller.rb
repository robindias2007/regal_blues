# frozen_string_literal: true

class ApplicationController < ActionController::API
  def formatted_message(condition, success_message, failure_message)
    if condition
      yield if block_given?
      render json: { message: success_message }, status: 200
    else
      render json: { errors: failure_message }, status: 404
    end
  end
end
