# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :sender, polymorphic: true, autosave: true, dependent: :destroy # Sender
  belongs_to :receiver, polymorphic: true, autosave: true, dependent: :destroy # Receiver

  belongs_to :support_chat 
  
  validate :either_message_or_attachment

  mount_base64_uploader :attachment, ImageUploader

  private

  def either_message_or_attachment
    errors.add(:message, 'both fields cannot be present') if message.present? && attachment.present?
  end
end
