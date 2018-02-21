# frozen_string_literal: true

class Support::PushTokensController < ApplicationController
  include PushNotification
    
  def index
  	@notification = Notification.new
  end

  # PUSH NOTIFICATION FOR ALL USERS
  def all_data_for_push
		push_array = Array.new
  	@users = User.where.not(devise_token:nil).each do |f|
			push_array.push(f.devise_token)
		end
		@push_token = PushToken.all.each do |f|
			push_array.push(f.token)
		end
		@push_array = push_array.uniq
  end

  def create
  	@notification = Notification.new(notification_params)
  	if  @notification.save!(validate:false)
      debugger
      if params[:commit] == "USER ID NULL"
        @notification.delay.publish_mass
  		elsif params[:commit] == "CLOSE REQUEST"
        @notification.delay.close_request   
      end  
      #all_data_for_push
      #   PushToken.where(user_id:nil).pluck(:token).each do |f|
  		#   send_notification(f, @notification.body, "", "")
  		# end
  		flash[:success] == "Done"
  		redirect_to push_token_path
  	else
  		redirect_to root_url
  	end
  end

  private

  def notification_params
  	params.require(:notification).permit(:body, :resourceable_type, :notificationable_type)
  end

end
