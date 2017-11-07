# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { pavan_says: 'Hi!' }
  end
end
