# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController

  def index
    conversations = current_user.conversations
    if conversations.present?
      render json: {conversation: {orders: conversations.where(receiver_type: "orders"), support_general: conversations.where(receiver_type: "support_general"), requests: conversations.where(receiver_type: "requests"), offers: conversations.where(receiver_type: "offers")}}, status: 201
    else
      render json: { errors: conversations.errors }, status: 400
    end
  end

  def create
    conversation = current_user.conversations.find_or_create_by(receiver_id: params[:receiver_id], receiver_type: params[:receiver_type])
    if conversation
      render json: {conversation: conversation}, status: 201
    else
      render json: { errors: conversation.errors }, status: 400
    end
  end

  def chat_type
    offers = request_conditional_offers.order(created_at: :desc).limit(20)
    user_chat_type = {support_general: Support.as_json, requests: current_user.requests, orders: current_user.orders, offers: Offer.as_json(offers)}
    
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

  # def chat_type_request
  #   offers = request_conditional_offers.order(created_at: :desc).limit(20)
  #   user_chat_type = {
  #                   support_general: Support.as_json, 
  #                   requests: current_user.requests.as_json(:only => [:id, :name, :max_budget], :include => {:sub_category => {:only => :name}} ), 
                    
  #                   orders: current_user.orders.as_json(:only => [:id], 
  #                                                     :include => {:offer_quotation => {:id} =>
  #                                                     {:include=> {:offer => 
  #                                                     {:include => {:request => {:only => :name}}}}}),
  #                   offers:   Offer.as_json(offers).as_json(:only => [:id, :request_id])
  #                   }
    
  #   if user_chat_type.present?
  #     render json: {user_chat_type: user_chat_type}, status: 201
  #   else
  #     render json: { errors: user_chat_type.errors }, status: 400
  #   end
  # end

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
