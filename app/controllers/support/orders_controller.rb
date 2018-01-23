class Support::OrdersController < ApplicationController
  
  def show
    @order = Order.find(params[:id])
  end

  def index
  	@orders = Order.all.order(updated_at: :desc)
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end