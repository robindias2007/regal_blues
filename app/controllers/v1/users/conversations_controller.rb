# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController
  def create
    conversation = Conversation.new(conversation_params)
    if conversation.save
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  def show
    
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

  # def conversation_params
  #   params.require(:conversation).permit(:message, :attachment)
  # end

  def conversation_params
    params.require(:conversation).permit(:receiver_id, :receiver_type, :sender_id)
  end
end
