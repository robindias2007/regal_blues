# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { asd: 'home' }
  end
end
