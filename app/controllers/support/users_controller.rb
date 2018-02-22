# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    if current_support.role == "admin"
      @users = User.order(created_at: :desc).all
      # @conversation = Conversation.new  
      # @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User" ) 
    else
      redirect_to root_url
    end
  end

  def show
    @user = if params[:query]
              User.search_for(search_params)
            else
              User.find(params[:id])
            end
    @conversation = Conversation.new
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@user).first 
    if params[:cold].present?
      debugger
      user = User.find(params[:id])
      user.update(cold:true)
    end
  end

  def update
    user = User.find(params[:id])
    debugger 
  end

  def create
    conversations = Conversation.between(current_support.common_id,params[:conversation][:conversationable_id])
    conversation = conversations.first if conversations.present?
    
    if !conversation.present?
      conversation = Conversation.new(conversation_params)
      if conversation.save
        redirect_to request.referrer
      else
        redirect_to request.referrer
      end
    end
  end

  private

  def conversation_params
    params.require(:conversation).permit(:receiver_id, :receiver_type,:conversationable_id, :conversationable_type)
  end

  def search_params
    params.require(:search).permit(:query)[:query].split('(').last.tr(')', '')
  end
end