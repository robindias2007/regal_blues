# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :support_chat

  mount_base64_uploader :attachment, ImageUploader
end
