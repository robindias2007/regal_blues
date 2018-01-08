class Notification < ApplicationRecord
	belongs_to :resourceable, polymorphic: true
	# validates :body, presence: true
end
