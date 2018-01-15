class Notification < ApplicationRecord
	belongs_to :resourceable, polymorphic: true
	belongs_to :notificationable, polymorphic: true
	# validates :body, presence: true
end
