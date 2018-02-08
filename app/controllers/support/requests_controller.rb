# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    req = Request.order(created_at: :desc)
    @requests = req.where(status:"active") + req.where(status:"pending") + req.where(status:"unapproved")
    @conversation = Conversation.new
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User" )
  end

  def chat
    @skip_header = true;
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    update_read_count = Conversation.find(@convo_id.id).messages.update_all(read:true)
    # request_id = Request.find(params[:id]).id
    # @convo_id = Request.find(request_id).user.conversations
  end

  def chat_post
    conversation = Conversation.find(params[:id])    
    @message = conversation.messages.new(message_params)
    @message.sender_id = current_support.common_id
    if @message.save!

      # render json: {message: Message.as_a_json(message)}, status: 201
      #render json: {message: message}, status: 201
      @message.update_attributes(body:params[:message][:body], conversation_id:params[:message][:conversation_id], attachment:params[:message][:attachment])
      redirect_to chat_path(params[:message][:conversation_id])
      else
      redirect_to root_url
      #render json: {message: message.errors}, status: 400
    end
  end


  def show
    @conversation = Conversation.new
    @request = Request.find(params[:id])
    request = Request.find(params[:id]) rescue nil
    if params[:commit] == "Update"
      request.update(description:params[:request][:description], max_budget:params[:request][:max_budget])
      flash[:success] = "Updated"
      redirect_to support_request_path(request)
    end
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@request.user).first 
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

  private
  def message_params
    params.require(:message).permit(:body, :attachment, :conversation_id)
  end

  def request_image_params
    params.require(:request_image).permit(:image, :request_id, :color, :serial_number)
  end
end
