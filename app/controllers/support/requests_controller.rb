# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @requests = Request.includes(:address, :request_designers, :offers, :sub_category).order(created_at: :desc).all
    @conversation = Conversation.new
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
    @message.sender_id = current_support.id
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
    @request = Request.find(params[:id])
    request = Request.find(params[:id]) rescue nil
    if params[:commit] == "Update"
      request.update(description:params[:request][:description], max_budget:params[:request][:max_budget])
      redirect_to support_request_path(request)
    end

    @request_image = RequestImage.new
    request_image = RequestImage.new(request_image_params) rescue nil
    if request_image.present?
      if request_image.save
        File.open("base64.txt","w") do |file|
          enc = file.write [File.open(params[:request_image][:image], "rb") {|io| io.read}].pack("m")
        end
        request_image.update(image:enc) 
        redirect_to support_request_path(request)
      end
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

  private
  def message_params
    params.require(:message).permit(:body, :attachment, :conversation_id)
  end

  def request_image_params
    params.require(:request_image).permit(:image, :request_id, :color, :serial_number)
  end
end
