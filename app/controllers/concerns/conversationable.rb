module Conversationable
  extend ActiveSupport::Concern

  def create

    if current_resource.class.name == "Support"
      #conversations = Conversation.between(current_resource.common_id,params[:receiver_id])
      #conversation = conversations.first if conversations.present?
      conversations = Conversation.between(current_resource.common_id,params[:conversationable_id])
      conversation = conversations.first if conversations.present?
    else
      conversations = Conversation.between(current_resource.id,params[:receiver_id])
      conversation = conversations.first if conversations.present?
    end

    if !conversation.present?
      if current_resource.class.name == "Support"
        conversation = Conversation.create(receiver_id: current_resource.common_id, receiver_type: "support", conversationable_id: params[:conversationable_id], conversationable_type: params[:conversationable_type])
      else
        conversation = current_resource.conversations.create(receiver_id: params[:receiver_id], receiver_type: params[:receiver_type])
      end
    end

    if conversation
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end
end