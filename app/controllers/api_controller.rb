# frozen_string_literal: true

class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: ['Resource not found'] }, status: 404
  end

  def formatted_response_if(condition, success, failure)
    if condition
      yield if block_given?
      render json: { message: success[0] }, status: success[1]
    else
      render json: { errors: [failure[0]] }, status: failure[1]
    end
  end
end
