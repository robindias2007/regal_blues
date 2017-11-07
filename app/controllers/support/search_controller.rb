# frozen_string_literal: true

class Support::SearchController < ApplicationController
  def users
    render json: User.search_for(search_params)
  end

  def designers
    render json: Designer.search_for(search_params)
  end

  def orders
    render json: Order.find_by(order_id: params[:query])
  end

  def users_suggestions
    render json: User.all.map(&:autocompleter).to_h
  end

  def designers_suggestions
    render json: Designer.all.map(&:autocompleter).to_h
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end
