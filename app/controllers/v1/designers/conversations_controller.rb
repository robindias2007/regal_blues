# frozen_string_literal: true

class V1::Designers::ConversationsController < V1::Designers::BaseController
  include Conversationable
  def index
    conversations = current_designer.conversations
    if conversations.present?
      render json: {conversation: {support_general: conversations.where(receiver_type: "support_general"), offers: conversations.where(receiver_type: "offers"), orders: conversations.where(receiver_type: "orders"), requests: conversations.where(receiver_type: "requests")}}, status: 201
    else
      render json: { errors: " No conversation found" }, status: 400
    end
  end

  def chat_type
    user_chat_type = {support_general: Support.as_json(current_designer), requests: current_designer.as_request_json, orders: current_designer.as_order_json, offers: current_designer.as_offer_json}
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
