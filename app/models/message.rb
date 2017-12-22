class Message < ApplicationRecord
	belongs_to :conversation
	mount_base64_uploader :attachment, ImageUploader
end
