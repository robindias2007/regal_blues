# frozen_string_literal: true

class Support::UsersController < ApplicationController
  def index
    users = User.order(created_at: :desc).paginate(:page => params[:current_page], :per_page => 100)
    respond_to do |format|
      format.html {@users = User.order(created_at: :desc).paginate(:page => params[:page], :per_page => 100)}
      format.csv do
        send_data users.to_csv
        @csv = true
      end
    end
  end

  def create_request
    @user = User.find(params[:id])
  end

  def show
    @user = if params[:query]
              User.search_for(search_params)
            else
              User.find(params[:id])
            end
    @conversation = Conversation.new
    @convo =  Conversation.where(receiver_type:"support", conversationable_type: "User", conversationable_id:@user).first 
  end

  def update
    user = User.find(params[:id])
    user.update(support_notes:params[:user][:support_notes])
    if params[:user][:hot] == "1"
      user.update(hot:true, cold:false, warm:false)
    elsif params[:user][:cold] == "1"
      user.update(hot:false, cold:true, warm:false)
    elsif params[:user][:warm] == "1"
      user.update(hot:false, cold:false, warm:true)        
    end     
    flash[:success] = "User Updated"
    redirect_to support_user_path(user)
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