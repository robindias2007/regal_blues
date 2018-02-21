class Notification < ApplicationRecord
  include PushNotification
	belongs_to :resourceable, polymorphic: true
	belongs_to :notificationable, polymorphic: true
	# validates :body, presence: true

  def publish_mass
    PushToken.where(user_id:nil).pluck(:token).each do |f|
      send_notification("548F5C9EA58072206BEF2B9AAB4A6C882A55315FCA49EC9D31A79FEBA3FFF0AA", self.body, "", "")
    end
  end
end
