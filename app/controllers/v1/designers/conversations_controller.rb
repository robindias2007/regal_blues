# frozen_string_literal: true

class V1::Designers::ConversationsController < V1::Designers::BaseController

  def index
    conversations = current_designer.conversations
    if conversations.present?
      render json: {conversation: {support_on_request: conversations.where(receiver_type: "support_on_request"), offers: conversations.where(receiver_type: "offers"), order_level: conversations.where(receiver_type: "order_level")}}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def create
    conversation = Conversation.new(conversation_params)
    if conversation.save
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  def chat_type
    user_chat_type = DesignerChatType.all
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
