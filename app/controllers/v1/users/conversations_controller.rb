# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController
  include Conversationable
  def index
    conversations = current_user.conversations
    if conversations.present?
      render json: {conversation: {orders: conversations.where(receiver_type: "orders"), support_general: conversations.where(receiver_type: "support_general"), requests: conversations.where(receiver_type: "requests"), offers: conversations.where(receiver_type: "offers")}}, status: 201
    else
      render json: { errors: "No conversation found" }, status: 400
    end
  end

  def chat_type
    offers = request_conditional_offers.order(created_at: :desc)
    user_chat_type = {support_general: Support.as_json(current_user), requests: current_user.as_request_json, orders: current_user.as_order_json, offers: Offer.as_json(offers, current_user)}
    
    if user_chat_type.present?
      render json: {user_chat_type: user_chat_type}, status: 201
    else
      render json: { errors: user_chat_type.errors }, status: 400
    end
  end

  def fetch_conversation
    conversation = current_user.conversations.where(receiver_id: params[:receiver_id])
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

  def request_conditional_offers
    if params[:request_id].present?
      Offer.find_for_user_and_request(current_user, params[:request_id])
    else
      Offer.find_for_user(current_user)
    end
  end
end
