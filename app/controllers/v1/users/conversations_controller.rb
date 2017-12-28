# frozen_string_literal: true

class V1::Users::ConversationsController < V1::Users::BaseController

  def index
    conversations = current_user.conversations
    if conversations.present?
      render json: {conversation: {order_level: conversations.where(receiver_type: "order_level"), support_on_general: conversations.where(receiver_type: "support_on_general"), request: conversations.where(receiver_type: "request"), offers: conversations.where(receiver_type: "offers")}}, status: 201
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
    offers = request_conditional_offers.order(created_at: :desc).limit(20)
    user_chat_type = {support_general: Support.as_json, requests: current_user.requests, orders: current_user.orders, offers: Offer.as_json(offers)}
    
    if user_chat_type.present?
      render json: {user_chat_type: user_chat_type}, status: 201
    else
      render json: { errors: user_chat_type.errors }, status: 400
    end
  end

  def chat_type_request
    offers = request_conditional_offers.order(created_at: :desc).limit(20)
    user_chat_type = {
                    support_general: Support.as_json, 
                    requests: current_user.requests.as_json(:only => [:id, :name, :max_budget, :sub_category_id], :include => {:sub_category => {:only => :name}} ), 
                    
                    orders: current_user.orders.as_json(:only => [:id], 
                                                      :include => {:offer_quotation => 
                                                      {:include=> {:offer => 
                                                      {:include => {:request => {:only => :name}}}}}}),
                    offers: Offer.as_json(offers).as_json(:only => [:id, :request_id], :include => {:request => {:only => :timeline}}, :include => {:designer => {:only => :full_name}})
                    }
    
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

  def request_conditional_offers
    if params[:request_id].present?
      Offer.find_for_user_and_request(current_user, params[:request_id])
    else
      Offer.find_for_user(current_user)
    end
  end
end
