# frozen_string_literal: true

class Support::PushTokensController < ApplicationController
  include PushNotification
    
  def index
  	@notification = Notification.new  
  end

  def create
  	@notification = Notification.new(notification_params)
  	if  @notification.save!(validate:false)
      if params[:commit] == "USER ID NULL"
        @notification.delay.user_nil
  		elsif params[:commit] == "CLOSE REQUEST"
        @notification.delay.close_request(@notification) 
      elsif params[:commit] == "SUBMIT REQUEST"
        @notification.delay.submit_request(@notification)
      elsif params[:commit] == "ALL USERS"    
        @notification.delay.all_users
      end  
      flash[:success] == "Push Notification Sent"
  		redirect_to push_token_path
  	else
  		redirect_to root_url
  	end
  end

  private

  def notification_params
  	params.require(:notification).permit(:body, :resourceable_type, :notificationable_type, :created_at)
  end

end
