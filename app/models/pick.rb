class Pick < ApplicationRecord
	mount_uploaders :images, ImageUploader
end
