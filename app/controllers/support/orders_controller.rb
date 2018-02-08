class Support::OrdersController < ApplicationController
  
  def show
    @order = Order.find(params[:id])
    @conversation = Conversation.new
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@order.user).first 
  end

  def index
    @orders = Order.order(created_at: :desc).all
    @order = Order.find(params[:format]) rescue nil
    if params[:commit] == 'Ship_To_QC'         # it checks if the user has clicked publish the it updates the form with publish
      @order.update(status:"shipped_to_qc")
      redirect_to request.referer
    elsif params[:commit] == 'Delivered_To_QC'
      @order.update(status:"delivered_to_qc")
      redirect_to request.referer
    elsif params[:commit] == "In_QC"
      @order.update(status:"in_qc")
      NotificationsMailer.under_qc(@order).deliver_now
      redirect_to request.referer
    elsif params[:commit] == 'Ship_To_User'
      @order.update(status:"shipped_to_user")
      NotificationsMailer.shipped_to_user(@order).deliver_now
      NotificationsMailer.designer_shipped(@order).deliver_now
      redirect_to request.referer
    elsif params[:commit] == 'Deliver_To_User'
      @order.update(status:"delivered_to_user")
      NotificationsMailer.product_deliverd(@order).deliver_now
      redirect_to request.referer
    elsif params[:commit] == 'Reject'
      @order.update(status:"rejected_by_qc")
      NotificationsMailer.rejected_in_qc(@order).deliver_now
      redirect_to request.referer
    end
    @conversation = Conversation.new
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User" )
  end

  private

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end