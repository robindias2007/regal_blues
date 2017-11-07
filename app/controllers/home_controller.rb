# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    if support_signed_in?
      #
    else
      render json: { pavan_says: 'Hi!' }
    end
  end
end
