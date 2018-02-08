# frozen_string_literal: true

# class V1::Users::ConversationsController < V1::Users::BaseController
class V1::Supports::ConversationsController < V1::Supports::BaseController
  include Conversationable
  def index
    conversations = current_support.conversations
    if conversations.present?
      render json: {conversation: {order_level: conversations.where(receiver_type: "order_level"), support_on_general: conversations.where(receiver_type: "support_on_general"), request: conversations.where(receiver_type: "request"), offers: conversations.where(receiver_type: "offers")}}, status: 201
    else
      render json: { errors: "No conversation found" }, status: 400
    end
  end

  def chat_type
    if params[:request_id].present?
      conversations = Request.find(params[:request_id]).user.conversations
    elsif params[:offer_id].present?
      conversations = Offer.find(params[:offer_id]).designer.conversations
    elsif params[:order_id].present?
      conversations = Order.find(params[:order_id]).user.conversations
    elsif params[:quotation_id].present?
      conversations = OfferQuotation.find(params[:quotation_id]).offer.designer.conversations
    elsif params[:support_id].present?
      conversations = Support.find(params[:support_id]).conversations
    end

    if conversations.present?
      render json: {conversation: conversations}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def fetch_conversation
    user_conv = Conversation.where(receiver_id: params[:receiver_id], conversationable_type: "User")
    degn_conv = Conversation.where(receiver_id: params[:receiver_id], conversationable_type: "Designer")
    if user_conv.present? || degn_conv.present?
      render json: {conversations: {user: user_conv, designer: degn_conv}}, status: 201
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
