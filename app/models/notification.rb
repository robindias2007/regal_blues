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
end
