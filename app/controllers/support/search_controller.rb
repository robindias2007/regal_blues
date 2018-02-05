# frozen_string_literal: true

class Support::SearchController < ApplicationController
  def users
    @user = User.search_for(search_params)
    if @user.present?
      render json: User.search_for(search_params)
    else
      render json: { message: "No users found with this email or name" }
    end
  end

  def designers
    @designer = Designer.search_for(search_params)
    if @designer.present?
      render json: Designer.search_for(search_params)
    else
      render json: { message: "No designers found with this email or name" }
    end
  end

  def orders
    @order = Order.find_by(order_id: params[:search][:query])
    if @order.present?
      render json: Order.find_by(order_id: params[:search][:query])
    else
      render json: { message: "Order not found" }
    end
  end

  def requests  
    @request = Request.find_by(name: params[:search][:query])
    if @request.present?
      render json: Request.find_by(name: params[:search][:query])
    else
      render json: { message: "Request not found" }
    end
  end

  def users_suggestions
    render json: User.all.map(&:autocompleter).to_h
  end

  def designers_suggestions
    render json: Designer.includes(:designer_store_info).all.map(&:autocompleter).to_h
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end
