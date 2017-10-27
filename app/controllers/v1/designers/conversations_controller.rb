# frozen_string_literal: true

class V1::Designers::ConversationsController < V1::Designers::BaseController
  def create
    conversation = Conversation.new(conversation_params)
    if conversation.save
      render json: { message: 'Conversation saved' }, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:message, :attachment, :support_chat_id)
  end
end
