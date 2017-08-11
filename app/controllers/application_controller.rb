# frozen_string_literal: true

class ApplicationController < ActionController::API
  def formatted_message(condition, success, failure)
    if condition
      yield if block_given?
      render json: { message: success[0] }, status: success[1]
    else
      render json: { errors: failure[0] }, status: failure[1]
    end
  end
end
