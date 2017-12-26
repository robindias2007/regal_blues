# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController

  def index
    conversations = current_user.conversations
    if conversations.present?
      render json: {conversation: {order_level: conversations.where(receiver_type: "order_level"), support_on_general: conversations.where(receiver_type: "support_on_general"), request: conversations.where(receiver_type: "request"), offers: conversations.where(receiver_type: "request")}}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def create
    conversation = current_user.conversations.new(conversation_params)
    if conversation.save
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  def chat_type
    user_chat_type = UserChatType.all
    if user_chat_type.present?
      render json: {user_chat_type: user_chat_type}, status: 201
    else
      render json: { errors: user_chat_type.errors }, status: 400
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:receiver_id, :receiver_type, :sender_id)
  end
end
