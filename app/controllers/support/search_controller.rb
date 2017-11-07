# frozen_string_literal: true

class Support::SearchController < ApplicationController
  def users; end

  def users_suggestions
    render json: User.all.map(&:autocompleter).to_h
  end

  def designers_suggestions
    render json: Designer.all.map(&:autocompleter).to_h
  end
end
