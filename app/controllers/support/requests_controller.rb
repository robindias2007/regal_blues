# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  #before_action :authenticate_support, :only => [:index]
  
  def index
    if current_support.role == "admin"
      req = Request.order(created_at: :desc)
      @requests = req.where(status:"active") + req.where(status:"pending") + req.where(status:"unapproved")
      # @conversation = Conversation.new
      # @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User" )
    else
      redirect_to root_url
    end
  end

  def chat
    @skip_header = true;
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    update_read_count = Conversation.find(@convo_id.id).messages.update_all(read:true)
  end

  def chat_post
    conversation = Conversation.find(params[:id])    
    @message = conversation.messages.new(message_params)
    @message.sender_id = current_support.common_id
    if @message.save!
      conversation.update(updated_at:DateTime.now)
      conversation.conversationable.update(updated_at:DateTime.now)
      redirect_to chat_path(@message.conversation_id)
    else
      flash[:notice] = "Chat Not Processed"
      redirect_to root_url
    end
  end


  def show
    @conversation = Conversation.new
    @request_image = RequestImage.new
    @request = Request.find(params[:id])
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@request.user).first 
  end

  def update
    request = Request.find(params[:id])
    request.update(description:params[:request][:description], max_budget:params[:request][:max_budget])
    if params[:request][:hot] == "1"
      request.update(hot:true, cold:false, warm:false)
    elsif params[:request][:cold] == "1"
      request.update(hot:false, cold:true, warm:false)
    elsif params[:request][:warm] == "1"
      request.update(hot:false, cold:false, warm:true)        
    end
  end

  def approve
    request = Request.find(params[:support_request_id])
    request.update!(status: :active)
    render json: { message: 'Request approved' }, status: 200
  end

  def reject
    request = Request.find(params[:support_request_id])
    request.update!(status: :unapproved)
    render json: { message: 'Request unapproved' }, status: 200
  end

  def show_request_quo
    @request = Request.find(params[:id])
  end

  def request_images
    request_image = RequestImage.new(request_image_params)
    if request_image.save!
      flash[:success] = "Image Uploaded"
      redirect_to request.referer
    else
      redirect_to support_requests_path
    end
  end

  private
  def message_params
    params.require(:message).permit(:body, :attachment, :conversation_id)
  end

  def request_image_params
    params.require(:request_image).permit(:image, :request_id, :color, :serial_number)
  end


end
