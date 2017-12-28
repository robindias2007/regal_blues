# frozen_string_literal: true

# class V1::Users::ConversationsController < V1::Users::BaseController
class V1::Supports::ConversationsController < V1::Supports::BaseController
  def index
    conversations = current_support.conversations
    if conversations.present?
      render json: {conversation: {order_level: conversations.where(receiver_type: "order_level"), support_on_general: conversations.where(receiver_type: "support_on_general"), request: conversations.where(receiver_type: "request"), offers: conversations.where(receiver_type: "offers")}}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def create
    conversation = current_support.conversations.new(conversation_params)
    if conversation.save
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
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
