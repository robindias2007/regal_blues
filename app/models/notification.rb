class Notification < ApplicationRecord
  include PushNotification
	belongs_to :resourceable, polymorphic: true
	belongs_to :notificationable, polymorphic: true
	# validates :body, presence: true

  	def user_nil
    	PushToken.where(user_id:nil).pluck(:token).each do |f|
      	send_notification(f, self.body, "", "")
    	end
 		end

  	def close_request(notification)
	    @events = Event.where('created_at >= ?', notification.created_at)
	    arr = []
	    @events.where(event_name:"CLOSE_REQUEST").pluck(:username).each do |f|
	      arr << User.find_by(username:f)
	    end
	    close_request = arr.compact.map(&:devise_token)
	    close_request.uniq.each do |f|
	      send_notification(f, self.body, "", "")
	    end
	  end

	  def submit_request(notification)
	    @events = Event.where('created_at >= ?', notification.created_at)
	    arr = []
	    @events.where(event_name:"SUBMIT_REQUEST").pluck(:username).each do |f|
	      arr << User.find_by(username:f)
	    end
	    close_request = arr.compact.map(&:devise_token)
	    close_request.uniq.each do |f|
	      send_notification(f, self.body, "", "")
	    end
	  end

	  def all_users
	  	all_users = (User.pluck(:devise_token) + PushToken.pluck(:token)).compact.uniq
	  	all_users.each do |f|
	  		send_notification(f, self.body, "", "")
	  	end
	  end

end
