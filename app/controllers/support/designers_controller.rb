# frozen_string_literal: true

class Support::DesignersController < ApplicationController
  def index
    @designers = Designer.order(full_name: :asc).all
  end

  def show
    @designer = Designer.find(params[:id])
  end

  def show_product_details
  	@product = Product.find(params[:id])
  end
end
