# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    @users = User.order(created_at: :desc).all
    @conversation = Conversation.new  
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User" ) 
  end

  def show
    @user = if params[:query]
              User.search_for(search_params)
            else
              User.find(params[:id])
            end
    @convo = Conversation.where(conversationable_type: "User")
  end

  def create
    conversation = Conversation.new(conversation_params)
    if conversation.save
      redirect_to request.referrer
    else
      redirect_to request.referrer
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
