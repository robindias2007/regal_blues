# frozen_string_literal: true

class V1::Designers::BaseController < ApplicationController
  before_action :authenticate

  def logged_in?
    current_designer.present?
  end

  def current_designer
    return unless auth_present?
    designer = Designer.find(auth['resource'])
    @current_designer ||= designer if designer
  end

  def authenticate
    render json: { errors: 'Unauthorized' }, status: 401 unless logged_in?
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
