# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @requests = Request.includes(:address, :request_designers, :offers, :sub_category).order(created_at: :desc).all
  end

  def chat
    @skip_header = true;
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    # request_id = Request.find(params[:id]).id
    # @convo_id = Request.find(request_id).user.conversations
  end

  def chat_post
    @message = Message.new(message_params)
    if @message.save!
      # render json: {message: Message.as_a_json(message)}, status: 201
      #render json: {message: message}, status: 201
      @message.update_attributes(body:params[:message][:body], conversation_id:params[:message][:conversation_id])
      redirect_to chat_path(params[:message][:conversation_id])
      else
      redirect_to root_url
      #render json: {message: message.errors}, status: 400
    end
  end


  def show
    @request = Request.find(params[:id])
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
end
