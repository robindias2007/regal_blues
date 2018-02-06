# frozen_string_literal: true

class Support::DesignersController < ApplicationController
  def index
    if current_support.role == "admin"
      @designers = Designer.order(full_name: :asc).all
      @convo =  Conversation.where(receiver_type:"support", conversationable_type: "Designer" )
      @conversation = Conversation.new
    else
      redirect_to root_url
    end
  end

  def show
    @designer = Designer.find(params[:id])
  end

  def show_product_details
  	@product = Product.find(params[:id])
  end
end
