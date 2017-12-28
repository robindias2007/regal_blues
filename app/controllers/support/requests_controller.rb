# frozen_string_literal: true

class Support::RequestsController < ApplicationController
  def index
    @requests = Request.includes(:address, :request_designers, :offers, :sub_category).order(created_at: :desc).all
  end

  def chat
    @convo_id = Conversation.find(params[:id])
    @message = Message.new()
    # request_id = Request.find(params[:id]).id
    # @convo_id = Request.find(request_id).user.conversations
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
end
