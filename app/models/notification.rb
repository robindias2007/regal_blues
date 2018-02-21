class Notification < ApplicationRecord
  include PushNotification
	belongs_to :resourceable, polymorphic: true
	belongs_to :notificationable, polymorphic: true
	# validates :body, presence: true

  def publish_mass
    PushToken.where(user_id:nil).pluck(:token).each do |f|
      send_notification(f, self.body, "", "")
    end
  end

  def close_request
    arr = []
    Event.where(event_name:"CLOSE_REQUEST").pluck(:username).each do |f|
      arr << User.find_by(username:f)
    end
    close_request = arr.compact.map(&:devise_token)
    close_request.each do |f|
      send_notification(f, self.body, "", "")
    end
  end

end
