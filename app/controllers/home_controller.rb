# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render json: { custumise_says: 'Hi!' }
  end
end
