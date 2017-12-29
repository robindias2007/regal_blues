# frozen_string_literal: true

class V1::Designers::ConversationsController < V1::Designers::BaseController

  def index
    conversations = current_designer.conversations
    if conversations.present?
      render json: {conversation: {support_general: conversations.where(receiver_type: "support_general"), offers: conversations.where(receiver_type: "offers"), orders: conversations.where(receiver_type: "orders"), requests: conversations.where(receiver_type: "requests")}}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def create
    conversation = current_designer.conversations.find_or_create_by(receiver_id: params[:receiver_id], receiver_type: params[:receiver_type])
    if conversation
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  def chat_type
    user_chat_type = {support_general: Support.as_json, requests: current_designer.requests, orders: current_designer.orders, offers: current_designer.offers}
    if user_chat_type.present?
      render json: {user_chat_type: user_chat_type}, status: 201
    else
      render json: { errors: user_chat_type.errors }, status: 400
    end
  end

  def fetch_conversation
    conversation = current_designer.conversations.where(receiver_id: params[:receiver_id])
    if conversation
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:receiver_id, :receiver_type, :sender_id)
  end

end
