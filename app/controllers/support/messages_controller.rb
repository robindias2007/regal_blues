# frozen_string_literal: true
class Support::MessagesController < ApplicationController
    
  def index
    @notification = Notification.new
  end

  def create
    @notification = Notification.new(notification_params)
    if  @notification.save!(validate:false)
      if params[:commit] == "CLOSE REQUEST"
        @notification.delay.close_request_message(@notification) 
      elsif params[:commit] == "SUBMIT REQUEST"
        @notification.delay.submit_request_message(@notification)
      elsif params[:commit] == "ALL USERS"    
        @notification.delay.all_users_message
      end
      flash[:success] == "Message Sent"
      redirect_to send_messages_path  
    else
      redirect_to root_url
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:body, :created_at)
  end

end
