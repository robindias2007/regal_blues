# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @requests = Request.includes(:address, :request_designers, :offers, :sub_category).order(created_at: :desc).all
  end
end
