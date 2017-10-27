# frozen_string_literal: true

class V1::Designers::SupportChatsController < V1::Designers::BaseController
  def create
    support_chat = SupportChat.find_or_initialize_by(designer: current_designer)
    if support_chat.save
      render json: support_chat, serializer: V1::Designers::SupportChatSerializer
    else
      render json: { errors: support_chat.errors }, status: 400
    end
  end

  def index
    # support_chat = SupportChat.find(params[:id])
    support_chat = current_designer.support_chat
    if support_chat.present?
      if support_chat&.conversations.present?
        render json:            support_chat.conversations.order(created_at: :asc),
               each_serializer: V1::Designers::ConversationSerializer
      else
        render json: { errors: 'Not conversations yet' }, status: 404
      end
    else
      render json: { errors: 'No chat initiated' }, status: 400
    end
  end
end
