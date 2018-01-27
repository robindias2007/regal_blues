class Support::OrdersController < ApplicationController
  
  def show
    @order = Order.find(params[:id])
  end

  def index
  	@orders = Order.all.order(updated_at: :desc)
    @order = Order.find(params[:format]) rescue nil
      if params[:commit] == 'Ship_To_QC'         # it checks if the user has clicked publish the it updates the form with publish
        @order.update(status:"shipped_to_qc")
        redirect_to support_orders_path
      elsif params[:commit] == 'Delivered_To_QC'
        @order.update(status:"delivered_to_qc")
        redirect_to support_orders_path
      elsif params[:commit] == "In_QC"
        @order.update(status:"in_qc")
        redirect_to support_orders_path
      elsif params[:commit] == 'Ship_To_User'
        @order.update(status:"shipped_to_user")
        redirect_to support_orders_path
      elsif params[:commit] == 'Deliver_To_User'
        @order.update(status:"delivered_to_user")
        redirect_to support_orders_path
      elsif params[:commit] == 'Reject'
        @order.update(status:"rejected_by_qc")
        redirect_to support_orders_path
      end
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end