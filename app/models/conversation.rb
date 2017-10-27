# frozen_string_literal: true

class Conversation < ApplicationRecord
  belongs_to :chattable, polymorphic: true, autosave: true, dependent: :destroy

  validate :either_message_or_attachment

  mount_base64_uploader :attachment, ImageUploader

  private

  def either_message_or_attachment
    errors.add(:message, 'both fields cannot be present') if message.present? && attachment.present?
  end
end
